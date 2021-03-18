//
//  GuideInteractor.swift
//  client
//
//  Created by Kanstantsin Bucha on 8.03.21.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import Foundation

protocol GuideInteractor {
    func connectBleDeviceWifi(ssid: String, pass: String) -> Future<Void>
    func checkConnectedDevice() -> Bool
    func handleSetWifiCredsResponse(status: Detecta_Response.ProcessingStatus)
}

class DefaultGuideInteractor: GuideInteractor {
    private var connectBleDeviceWifiPromise: Promise<Void>?
    public init() {}
    
    func connectBleDeviceWifi(ssid: String, pass: String) -> Future<Void> {
        log.operation("Connect Ble Device Wifi")
        guard checkConnectedDevice() else {
            let error = GuideInteractorError.noDevice
            log.error(error)
            log.failure("Connect Ble Device Wifi")
            return Promise<Void>.rejected(error: error)
        }
        guard ssid.count < 15 && ssid.count > 0 else {
            let error = GuideInteractorError.ssidInvalid
            log.error(error)
            log.failure("Connect Ble Device Wifi")
            return Promise<Void>.rejected(error: error)
        }
        guard pass.count < 15 && pass.count > 0 else {
            let error = GuideInteractorError.passInvalid
            log.error(error)
            log.failure("Connect Ble Device Wifi")
            return Promise<Void>.rejected(error: error)
        }
        let promise = Promise<Void>()
        connectBleDeviceWifiPromise = promise
        do {
            try service(GatesKeeper.self).bleGate.requestSetWifiCreds(
                ssid: ssid,
                pass: pass
            )
        } catch {
            return Promise<Void>.rejected(error: error)
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(5)) { [weak self] in
            if self?.connectBleDeviceWifiPromise === promise {
                promise.reject(GuideInteractorError.timeout)
                self?.connectBleDeviceWifiPromise = nil
            }
        }
        return promise
    }
    
    func handleSetWifiCredsResponse(status: Detecta_Response.ProcessingStatus) {
        if !status.isError {
            connectBleDeviceWifiPromise?.resolve(())
        } else {
            connectBleDeviceWifiPromise?.reject(status)
        }
        connectBleDeviceWifiPromise = nil
    }
    
    func checkConnectedDevice() -> Bool {
        service(GatesKeeper.self).bleGate.isOpen
    }
}
