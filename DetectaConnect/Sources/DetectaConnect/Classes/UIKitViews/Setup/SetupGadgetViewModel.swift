//
//  SetupGadgetViewModel.swift
//  client
//
//  Created by Kanstantsin Bucha on 8.03.21.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import Foundation
import Combine

public enum SetupGadgetViewState {
    case connecting
    case connected
    case settingUp
    case setUp
}

public protocol SetupGadgetViewModel {
    var stateSubject: Subject<SetupGadgetViewState> { get }
    func setupDevice(ssid: String, pass: String)
    func viewWillAppear()
}

public class DefaultSetupGadgetViewModel: SetupGadgetViewModel {
    public var stateSubject = Subject<SetupGadgetViewState>()
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
