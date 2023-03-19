import Foundation

class HomeViewModel {
    var observeDevices: Observe<[Device]>? = nil
    private let persistence: DevicePersistence
    
    init(persistence: DevicePersistence) {
        self.persistence = persistence
    }
    
    func onViewAppear() {
        observeDevices?(persistence.loadAll())
    }
    
    func delete(device: Device) {
        persistence.deleteDevice(id: device.id)
        observeDevices?(persistence.loadAll())
    }
}
