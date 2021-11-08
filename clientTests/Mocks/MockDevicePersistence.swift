//
//  MockDevicePersistence.swift
//  DetectaConnectTests
//
//  Created by Aleksandr Bucha on 04/10/2021.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import Foundation
import DetectaConnect

class MockDevicePersistence: DevicePersistence {
    
    private(set) var saveCount = 0
    private(set) var saveParams: Device?
    var loadResult: Device?
    
    func loadAll() -> [Device] {
        []
    }
    
    func load(id: String) -> Device? {
        loadResult
    }
    
    func save(device: Device) {
        saveParams = device
        saveCount += 1
    }
}

