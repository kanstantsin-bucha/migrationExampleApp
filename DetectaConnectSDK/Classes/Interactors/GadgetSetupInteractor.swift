//
//  GuideInteractor.swift
//  client
//
//  Created by Kanstantsin Bucha on 8.03.21.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import Foundation

protocol GadgetSetupInteractor {
    func connectBleDeviceWifi(ssid: String, pass: String) -> Future<Void>
    func checkConnectedDevice() -> Bool
    func handleSetupResponse(status: D_Resp.Status, token: String)
}

class DefaultGadgetSetupInteractor: GadgetSetupInteractor {
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
        guard ssid.count <= 16 && ssid.count > 0 else {
            let error = GuideInteractorError.ssidInvalid
            log.error(error)
            log.failure("Connect Ble Device Wifi")
            return Promise<Void>.rejected(error: error)
        }
        guard pass.count <= 16 && pass.count > 0 else {
            let error = GuideInteractorError.passInvalid
            log.error(error)
            log.failure("Connect Ble Device Wifi")
            return Promise<Void>.rejected(error: error)
        }
        let promise = Promise<Void>()
        connectBleDeviceWifiPromise = promise
        do {
            try service(GatesKeeper.self).bleGate.requestSetup(
                ssid: ssid,
                pass: pass
            )
        } catch {
            return Promise<Void>.rejected(error: error)
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(25)) { [weak self] in
            onSerial {
                if self?.connectBleDeviceWifiPromise === promise {
                    promise.reject(GuideInteractorError.timeout)
                    self?.connectBleDeviceWifiPromise = nil
                }
            }
        }
        return promise
    }
    
    func handleSetupResponse(status: D_Resp.Status, token: String) {
        onSerial { [weak self] in
            if !status.isError {
                self?.updateDevice(token: token)
                self?.connectBleDeviceWifiPromise?.resolve(())
            } else {
                self?.connectBleDeviceWifiPromise?.reject(status)
            }
            self?.connectBleDeviceWifiPromise = nil
        }
    }
    
    func checkConnectedDevice() -> Bool {
        service(GatesKeeper.self).bleGate.isOpen
    }
    
    private func updateDevice(token: String) {
        let persistence = service(DevicePersistence.self)
        guard persistence.load(id: token) == nil else { return }
        let device = DefaultDevice(id: token, name: "D-Air", token: token, date: Date())
        
        persistence.save(device: device)
    }
}