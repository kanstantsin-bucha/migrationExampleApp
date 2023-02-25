import Foundation
import Combine

public class SetupGadgetViewModel {
    public var stateSubject = Subject<ViewState>()
    public let secondsToRepeat: Int
    
    public init(secondsToRepeat: Int = 3) {
        self.secondsToRepeat = secondsToRepeat
    }
    
    public func viewWillAppear() {
        checkDevice()
    }
    
    public func setupDevice(ssid: String, pass: String) {
        log.user("Setup Gadget")
        stateSubject.send(.settingUp)
        _ = service(GadgetSetupInteractor.self).connectBleDeviceWifi(
            ssid: ssid,
            pass: pass
        ).onFailure { [weak self] error in
            self?.checkDevice()
            service(AlertRouter.self).show(error: error)
        }.onSuccess { [weak self] _ in
            self?.stateSubject.send(.setUp)
        }
    }
    
    private func checkDevice() {
        log.debug("Check Gadget")
        if service(GadgetSetupInteractor.self).checkConnectedDevice() {
            stateSubject.send(.connected)
        } else {
            stateSubject.send(.connecting)
            onMain(afterSeconds: secondsToRepeat) { [weak self] in
                self?.checkDevice()
            }
        }
    }
}

extension SetupGadgetViewModel {
    public enum ViewState {
        case connecting
        case connected
        case settingUp
        case setUp
    }
}
