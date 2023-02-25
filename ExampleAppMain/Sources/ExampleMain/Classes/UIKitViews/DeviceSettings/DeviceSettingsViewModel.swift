import Foundation

public class DeviceSettingsViewModel {
    var name: String { device?.name ?? "" }
    var token: String { device?.token ?? "" }
    private let deviceID: String
    private var device: Device?
    
    public init(deviceID: String) {
        self.deviceID = deviceID
    }
    
    public func onViewWillAppear() {
        device = service(DevicePersistence.self).load(id: deviceID)
    }
    
    public func syncDevice(name: String?) {
        guard let name, var device, device.update(name: name) else { return }
        service(DevicePersistence.self).save(device: device)
    }
}
