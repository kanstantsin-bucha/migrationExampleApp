//
//  DevicePersistence.swift
//  DetectaConnectSDK
//
//  Created by Konstantin Bucha on 4/11/21.
//

import Foundation

protocol DevicePersistence {
    func loadAll() -> [Device]
    func load(id: String) -> Device?
    func save(device: Device)
}

class DefaultDevicePersistence: DevicePersistence {
    let dictKey = "app.devices.dict"
    
    func loadAll() -> [Device] {
        return Array(loadDict().values).sorted { $0.name > $1.name }
    }
    
    func load(id: String) -> Device? {
        return loadDict()[id]
    }
    
    func save(device: Device) {
        var dict = loadDict()
        dict[device.id] = device
        save(dict: dict as! [String: DefaultDevice])
    }
    
    // MARK: - Private methods
    
    func loadDict() -> [String: Device] {
        guard let json = UserDefaults().data(forKey: dictKey) else { return [:] }
        return (try? JSONDecoder().decode([String: DefaultDevice].self, from: json)) ?? [:]
    }
    
    func save<Item: Encodable>(dict: [String: Item]) {
        let json = try? JSONEncoder().encode(dict)
        UserDefaults().setValue(json, forKey: dictKey)
    }
}
