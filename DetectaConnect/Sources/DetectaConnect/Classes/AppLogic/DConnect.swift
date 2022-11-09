//
//  AppDelegate.swift
//  client
//
//  Created by Kanstantsin Bucha on 6/10/19.
//  Copyright © 2019 Detecta Group. All rights reserved.
//

import UIKit
import Sentry

public class DConnect {
    @available(iOSApplicationExtension, unavailable)
    
    public static var assetsBundle: Bundle {
        return Bundle.module
    }
    
    public static func initialize() -> DConnect {
        SentrySDK.start { options in
            options.dsn = "https://bf1536e15da64ef1b3eae67383d8e868@o1153823.ingest.sentry.io/6244980"
            options.debug = false
        }
        
        setupServices()
        service(GatesKeeper.self).summonAll()
        return DConnect()
    }
    
    public func setup(window: UIWindow) {
        service(AppRouter.self).start(window: window)
    }
    
    public func applicationWillEnterForeground() {
        service(EnvironmentRisksEvaluator.self).updateModelFromCloud()
    }
    
    public func applicationDidBecomeActive() {
        service(GatesKeeper.self).notificationsGate.open()
    }
    
    public func didRegisterForRemoteNotifications(deviceToken: Data) {
        service(GatesKeeper.self).notificationsGate.handle(deviceToken: deviceToken)
    }
    
    public func didFailToRegisterForRemoteNotifications(error: Error) {
        service(GatesKeeper.self)
            .notificationsGate
            .handleFailToRegister(error: error)
    }
}

