import Foundation

final class BleGate {
    private(set) var isOpen = false
    private(set) var isConnecting = false
}

extension BleGate: GateKeeper {
    func summon() {}
    
    func open() {
        log.debug("Ble open")
        
        isConnecting = true
        connect()
    }
    
    func close() {
        log.operation("Ble close")
        
        isConnecting = false
        isOpen = false
    }
    
    private func connect() {
        log.operation("Ble connect")
        self.isOpen = true
    }
}

extension BleGate: BleTransmitter {
    func requestSetup(
        ssid: String,
        pass: String
    ) throws {
        service(GadgetSetupInteractor.self).handleSetupResponse(
            status: true,
            token: UUID().uuidString
        )
    }
}
