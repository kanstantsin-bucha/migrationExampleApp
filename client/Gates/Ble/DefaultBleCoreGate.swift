//
//  BleGate.swift
//  client
//
//  Created by bucha on 6/16/19.
//  Copyright © 2019 Detecta Group. All rights reserved.
//

import Foundation
import BlueSwift
import BuchaSwift
import CoreBluetooth
import SwiftProtobuf

final class DefaultBleCoreGate: NSObject {
    private(set) var isOpen = false
    private(set) var isConnecting = false
    
    private var dAirPeripheral: Peripheral<Connectable>!
    private var rxChar: Characteristic!
    private var txChar: Characteristic!
    
    // MARK: - Private methods
    
    private func makeDAirPeripheral() {
        txChar = Characteristic(Constant.Ble.Commands.Tx.uuid)
        
        rxChar = Characteristic(
            Constant.Ble.Commands.Rx.uuid,
            isObserving: true
        )
        
        txChar.notifyHandler = { data in
            log.event("the transmit characteristic received a data")
            log.error("the transmit characteristic received a data")
            log.debug("tx data \(String(describing: data))")
        }
        
        rxChar.notifyHandler = { [weak self] data in
            
            self?.handleRx(data: data)
        }
        
        let service = Service(
            Constant.Ble.Commands.uuid,
            characteristics: [ txChar, rxChar ]
        )
        
        let configuration = Configuration(
            Constant.Ble.Commands.uuid,
            services: [service]
        )
        
        dAirPeripheral = Peripheral(configuration: configuration)
        
        log.debug("""
            peripheral \(dAirPeripheral.isConnected) \(dAirPeripheral.configuration)
            \(rxChar.uuid)
            \(txChar.uuid)
            """
        )
    }
    
    private func sendTx(data: Data) {
        log.operation("sendTx \(data.hexEncodedString())")
        dAirPeripheral.write(
            command: .data(data),
            characteristic: txChar,
            type: .withResponse
        ) { error in
            guard let error = error else {
                log.success("sendTx")
                return
            }
            log.error("sendTx: \(error)")
            log.failure("sendTx")
        }
    }
    
    private func handleRx(data: Data?) {
        guard let data = data, data.count > 0 else {
            print("Error: the receive haracteristic recieved no data")
            return
        }
        log.debug("handleRx \(data.hexEncodedString())")
        
        let response: Detecta_Response
        do {
            response = try Detecta_Response(serializedData: data)
        } catch {
            log.error("handleRx: \(error)")
            return
        }
        log.event("response session: \(response.sessionID), commandId: \(response.requestID)")
        
        guard let message = response.message else {
            let info = "session: \(response.sessionID), packet: \(response.requestID)"
            log.error("handleRx message is nil, packetId: \(info)")
            return
        }
        
        switch message {
        case .getContextValues(let values):
            log.event("getContextValues \(values.timestamp) \(values.tempCelsius)")
            postContextChangesNotification(values: values)
            
        case .setWifiState(let status):
            log.event("setWifiState: \(status)")
//            service(GuideInteractor.self).handleSetWifiCredsResponse(status: status.status)
        
        case .setWifiCreds(let status):
            log.event("setWifiCreds: \(status)")
            service(GuideInteractor.self).handleSetWifiCredsResponse(status: status.status)
            
        case .getWifiNetworkInfo(let info):
            log.event("getWifiNetworkInfo: \(info.ipAddr), \(info.mDnsname), \(info.isConnected)")
        
        }
    }
    
    private func postContextChangesNotification(values: ContextValues) {
        let notification = Notification(
            name: Constant.Notifications.ContextUpdate.name,
            userInfo: [
                Constant.Notifications.ContextUpdate.values: values
            ]
        )
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }
}

extension DefaultBleCoreGate: GateKeeper {
    func summon(
        infoDictionary: [String : Any]?,
        launchOptions: [AnyHashable : Any]?
    ) {
        makeDAirPeripheral()
    }
    
    func open() {
        log.debug("Ble open")
        
        isConnecting = true
        connect()
    }
    
    func close() {
        log.operation("Ble close")
        
        isConnecting = false
        isOpen = false
        
        if let peri = dAirPeripheral {
            BluetoothConnection.shared.disconnect(peri)
            makeDAirPeripheral()
        }
        BluetoothConnection.shared.stopScanning()
    }
    
    private func connect() {
        log.operation("Ble connect")
        BluetoothConnection.shared.connect(dAirPeripheral) { [weak self] error in
            guard let self = self, self.isConnecting else {
                log.cancel("Ble connect - is Connecting false")
                return
            }
            
            guard error == nil else {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) { [weak self] in
                    self?.connect()
                }
                log.failure("Ble connect \(error)")
                return
            }
            self.isOpen = true
            log.success("Ble connect")
        }
    }
}

extension DefaultBleCoreGate: BleTransmitter {
    func requestSetWifiState(isEnabled: Bool) throws {
        var wifiState = Detecta_Request.SetWifiState()
        wifiState.isEnabled = isEnabled
        var message = Detecta_Request()
        message.setWifiState = wifiState
        try transmit(message: message)
    }
    
    func requestSetWifiCreds(
        ssid: String,
        pass: String
    ) throws {
        guard ssid.count < 16 && pass.count < 16 else {
            throw BleGateError.incosistentData
        }
        var wifiCreds = Detecta_Request.SetWifiCreds()
        wifiCreds.said = ssid
        wifiCreds.password = pass
        var message = Detecta_Request()
        message.setWifiCreds = wifiCreds
        try transmit(message: message)
    }
    
    func requestGetWifiNetworkInfo() throws {
        let networkInfo = Detecta_Request.GetWifiNetworkInfo()
        var message = Detecta_Request()
        message.getWifiNetworkInfo = networkInfo
        try transmit(message: message)
    }
    
    private func transmit(message: SwiftProtobuf.Message) throws {
        do {
            let data = try message.serializedData()
            sendTx(data: data)
        } catch {
            throw BleGateError.protobufEncoding(error: error)
        }
    }
}
