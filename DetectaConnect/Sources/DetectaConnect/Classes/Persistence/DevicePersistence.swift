//
//  DevicePersistence.swift
//  DetectaConnect
//
//  Created by Konstantin Bucha on 4/11/21.
//

import Foundation

public protocol DevicePersistence {
    func loadAll() -> [Device]
    func load(id: String) -> Device?
    func save(device: Device)
    func deleteDevice(id: String)
    
    var deviceId: String { get }
}

class DefaultDevicePersistence: Service, DevicePersistence {
    private let dictKey = "app.devices.dict"
    private let deviceIdKey = "app.deviceId.uuid"
    
    func loadAll() -> [Device] {
        return Array(loadDict().values).sorted { $0.date > $1.date }
    }
    
    func load(id: String) -> Device? {
        return loadDict()[id]
    }
    
    func save(device: Device) {
        var dict = loadDict()
        dict[device.id] = device
        save(dict: dict)
    }
    
    func deleteDevice(id: String) {
        var dict = loadDict()
        dict[id] = nil
        save(dict: dict)
    }
    
    var deviceId: String {
        guard let persistedId = UserDefaults().string(forKey: deviceIdKey) else {
            let id = "d-connect-ios-" + UUID().uuidString.lowercased()
            UserDefaults().setValue(id, forKey: deviceIdKey)
            return id
        }
        return persistedId
    }
    
    // MARK: - Private methods
    
    private func loadDict() -> [String: Device] {
        guard let json = UserDefaults().data(forKey: dictKey) else { return [:] }
        return (try? JSONDecoder().decode([String: Device].self, from: json)) ?? [:]
    }
    
    private func save<Item: Encodable>(dict: [String: Item]) {
        let json = try? JSONEncoder().encode(dict)
        UserDefaults().setValue(json, forKey: dictKey)
    }
}
