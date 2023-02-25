import Foundation
import ExampleMain

class MockDevicePersistence: DevicePersistence, Service {
    var deviceId: String = UUID().uuidString
    
    func loadAll() -> [Device] {
        []
    }
    
    private(set) var loadCount = 0
    private(set) var loadParams: String?
    var loadResult: Device?
    func load(id: String) -> Device? {
        loadCount += 1
        loadParams = id
        return loadResult
    }
    
    private(set) var saveCount = 0
    private(set) var saveParams: Device?
    func save(device: Device) {
        saveParams = device
        saveCount += 1
    }
    
    func deleteDevice(id: String) {}
}

