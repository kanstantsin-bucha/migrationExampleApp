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
    
    private var dAirPeripheral: Peripheral<Connectable>!
    private var rxChar: Characteristic!
    private var txChar: Characteristic!
    
    // MARK: - Private methods
    
    private func makeDAirPeripheral() throws {
        txChar = try Characteristic(
            uuid: Constant.Ble.Commands.Tx.uuid,
            shouldObserveNotification: true
        )
        
        rxChar = try Characteristic(
            uuid: Constant.Ble.Commands.Rx.uuid,
            shouldObserveNotification: true
        )
        
        txChar.notifyHandler = { data in
            print("Error: the transmit characteristic received a data")
            print("tx data \(String(describing: data))")
        }
        
        rxChar.notifyHandler = { [weak self] data in
            
            self?.handleRx(data: data)
        }
        
        let service = try Service(
            uuid: Constant.Ble.Commands.uuid,
            characteristics: [ txChar, rxChar ]
        )
        
        let configuration = try Configuration(
            services: [service],
            advertisement: Constant.Ble.Commands.uuid
        )
        
        dAirPeripheral = Peripheral(configuration: configuration)
        
        print("""
            peripheral \(dAirPeripheral.isConnected) \(dAirPeripheral.configuration)
            \(rxChar.uuid)
            \(txChar.uuid)
            """
        )
    }
    
    private func sendTx(data: Data) {
        print("sendRx \(data.hexEncodedString())")
        dAirPeripheral.write(
            command: .data(data),
            characteristic: txChar,
            type: .withResponse
        ) { error in
            guard let error = error else {
                print("Transmit suceeds")
                return
            }
            print("Transmit error: \(error)")
        }
    }
    
    private func handleRx(data: Data?) {
        guard let data = data, data.count > 0 else {
            print("Error: the receive haracteristic recieved no data")
            return
        }
        print("handleRx \(data.hexEncodedString())")
        
        let response: Detecta_Response
        do {
            response = try Detecta_Response(serializedData: data)
        } catch {
            print("handleRx: \(error)")
            return
        }
        
        guard let message = response.message else {
            let info = "session: \(response.sessionID), packet: \(response.requestID)"
            print("handleRx message is nil, packetId: \(info)")
            return
        }
        
        switch message {
        case .getContextValues(let values):
            print("rx: getContextValues \(values.coPpm) \(values.tempCelsius)")
            postContextChangesNotification(values: values)
        case .setWifiState(let status):
            print("rx: setWifiState \(status)")
            
        default:
            print("rx: other message")
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
    ) throws {
        try makeDAirPeripheral()
    }
    
    func open() throws {
        print("BleCoreGate open")
        
        isOpen = true
        
        BluetoothConnection.shared.connect(dAirPeripheral) { error in
            guard error == nil else {
    
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [weak self] in
                    
                    try? self?.open()
                }
                print("connecting, got error \(String(describing: error))")
                return
            }
            print("connected")
        }
    }
    
    func close() {
        print("BleCoreGate close")
        
        isOpen = false
        
        if let peri = dAirPeripheral {
            
            BluetoothConnection.shared.disconnect(peri)
            try? makeDAirPeripheral()
        }
        BluetoothConnection.shared.stopScanning()
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
