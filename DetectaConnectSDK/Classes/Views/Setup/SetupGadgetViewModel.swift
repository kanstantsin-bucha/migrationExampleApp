//
//   SetupGadgetViewModel.swift
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
    var state: PassthroughSubject<SetupGadgetViewState, Never> { get }
    func setupDevice(ssid: String, pass: String)
    func viewWillAppear()
}

public class DefaultSetupGadgetViewModel: SetupGadgetViewModel {
//    public var state: Published<SetupGadgetViewState>.Publisher { $_state }
    public var state = PassthroughSubject<SetupGadgetViewState, Never>()
    
    public init() {}
    
    public func viewWillAppear() {
        checkDevice()
    }
    
    public func setupDevice(ssid: String, pass: String) {
        log.user("Setup Gadget")
        state.send(.settingUp)
        _ = service(GadgetSetupInteractor.self).connectBleDeviceWifi(
            ssid: ssid,
            pass: pass
        ).onFailure { [weak self] error in
            self?.checkDevice()
            service(AlertRouter.self).show(error: error)
        }.onSuccess { [weak self] _ in
            self?.state.send(.setUp)
        }
    }
    
    private func checkDevice() {
        log.debug("Check Gadget")
        if service(GadgetSetupInteractor.self).checkConnectedDevice() {
            state.send(.connected)
        } else {
            state.send(.connecting)
            onMain(afterSeconds: 3) { [weak self] in
                self?.checkDevice()
            }
        }
    }
}
