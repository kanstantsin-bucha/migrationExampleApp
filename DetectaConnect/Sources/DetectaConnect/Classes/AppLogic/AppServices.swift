//
//  AppServices.swift
//  client
//
//  Created by Kanstantsin Bucha on 8.03.21.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import Foundation

public func service<T>(_ type: T.Type) -> T {
    locator.service(type: type)
}

public func addService(_ type: Any.Type, impl: AnyObject) {
    locator.addService(type, impl: impl)
}

public func removeAllServices() {
    locator.removeAll()
}

@available(iOSApplicationExtension, unavailable)
func setupServices() {
    do {
        locator.addServices([
            (GatesKeeper.self, DefaultGatesKeeper()),
            (GadgetSetupInteractor.self, DefaultGadgetSetupInteractor()),
            (AppRouter.self, DefaultAppRouter()),
            (AlertRouter.self, DefaultAlertRouter()),
            (NetworkService.self, DefaultNetworkService()),
            (DevicePersistence.self, DefaultDevicePersistence()),
            (ChartInteractor.self, ChartInteractor()),
            (EnvironmentRisksEvaluator.self, try EnvironmentRisksEvaluator())
        ])
    } catch {
        let message = "Failed to setup services with error: \(error)"
        log.error(message)
        preconditionFailure(message)
    }
}

fileprivate let locator = ServiceLocator()

fileprivate class ServiceLocator {
    private lazy var list: [String: AnyObject] = [:]
    
    func addServices(_ services: [(type: Any.Type, impl: AnyObject)]) {
        services.forEach { addService($0.type, impl: $0.impl)}
    }

    func addService(_ type: Any.Type, impl: AnyObject) {
        list[key(type: type)] = impl
    }

    func service<T>(type: T.Type) -> T {
        return list[key(type: type)] as! T
    }
    
    private func key(type: Any.Type) -> String {
        return "\(type.self)"
    }
    
    func removeAll() {
        list = [:]
    }
}
