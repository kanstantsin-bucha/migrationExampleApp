//
//  MockDeviceContainer.swift
//  DetectaConnectTests
//
//  Created by Aleksandr Bucha on 04/10/2021.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import Foundation
import DetectaConnect

class MockDeviceContainer: DeviceContainer {
    public var deviceResult: Device!
    private(set) var clearCacheCount = 0
    
    override var device: Device {
        deviceResult
    }
    
    init() {
        super.init(deviceId: "")
    }
    
    override func clearCache() {
        clearCacheCount += 1
    }
}
