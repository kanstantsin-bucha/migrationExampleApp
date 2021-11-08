//
//  DeviceContainer.swift
//  DetectaConnect
//
//  Created by Konstantin on 7/25/21.
//

import Foundation

open class DeviceContainer {
    private let deviceId: String
    private var cachedDevice: Device?
    
    open var device: Device {
        if let device = cachedDevice {
            return device
        }
        guard let device = service(DevicePersistence.self).load(id: deviceId) else {
            preconditionFailure(#fileID + " Device cannot be nil")
        }
        cachedDevice = device
        return device
    }
    
    public init(deviceId: String) {
        self.deviceId = deviceId
    }
    
    open func clearCache() {
        cachedDevice = nil
    }
}
