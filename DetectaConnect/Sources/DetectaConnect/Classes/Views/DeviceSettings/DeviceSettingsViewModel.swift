//
//  DeviceSettingsViewModel.swift
//  BlueSwift
//
//  Created by Konstantin on 7/25/21.
//

import Foundation

public class DeviceSettingsViewModel {
    var deviceName: String { deviceContainer.device.name }
    private let deviceContainer: DeviceContainer
    
    public init(deviceContainer: DeviceContainer) {
        self.deviceContainer = deviceContainer
    }
    
    public func syncDevice(name: String?) {
        var device = deviceContainer.device
        deviceContainer.clearCache()
        guard let name = name, device.update(name: name) else { return }
        service(DevicePersistence.self).save(device: device)
    }
}
