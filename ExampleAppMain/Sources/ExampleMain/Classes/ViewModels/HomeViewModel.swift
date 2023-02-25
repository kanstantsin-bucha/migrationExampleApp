import Foundation

class HomeViewModel {
    var observeDevices: Observe<[Device]>? = nil
    
    func onViewAppear() {
        observeDevices?(service(DevicePersistence.self).loadAll())
    }
    
    func delete(device: Device) {
        service(DevicePersistence.self).deleteDevice(id: device.id)
        observeDevices?(service(DevicePersistence.self).loadAll())
    }
}
