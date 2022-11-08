//
//  MockGadgetSetupInteractor.swift
//  DetectaConnectTests
//
//  Created by Aleksandr Bucha on 22/10/2021.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import DetectaConnect
import Foundation
import XCTest

class MockGadgetSetupInteractor: GadgetSetupInteractor, Service {
    var connectBleDeviceWifiResult: Result<Void, Error> = .failure(TestError())
    var checkConnectedDeviceResults: [Bool] = []
    private(set)var checkConnectedDeviceCount = 0
    let checkConnectedDeviceResultExpectation = XCTestExpectation(description: "CheckConnectedDeviceResult")
    
    private(set) var connectBleDeviceWifiParams: (ssid: String, pass: String)?
    private(set) var connectBleDeviceWifiCount = 0
    
    func connectBleDeviceWifi(ssid: String, pass: String) -> Future<Void> {
        connectBleDeviceWifiParams = (ssid: ssid, pass: pass)
        connectBleDeviceWifiCount += 1
        
        return Promise<Void>.resolved(result: connectBleDeviceWifiResult)
    }
    
    func checkConnectedDevice() -> Bool {
        guard !checkConnectedDeviceResults.isEmpty else {
            checkConnectedDeviceResultExpectation.fulfill()
            return false
        }
        let result = checkConnectedDeviceResults.removeFirst()
        if checkConnectedDeviceResults.isEmpty {
            checkConnectedDeviceResultExpectation.fulfill()
        }
        return result
    }
    
    func handleSetupResponse(status: D_Resp.Status, token: String) {
        
    }
}
