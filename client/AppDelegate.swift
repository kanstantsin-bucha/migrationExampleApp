//
//  AppDelegate.swift
//  client
//
//  Created by bucha on 6/10/19.
//  Copyright © 2019 Detecta Group. All rights reserved.
//

import UIKit
import DetectaConnect

class AppDelegate: UIResponder, UIApplicationDelegate {
    var engine: DConnect?
    
    // MARK: - Notifications

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        engine?.didRegisterForRemoteNotifications(deviceToken: deviceToken)
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        engine?.didFailToRegisterForRemoteNotifications(error: error)
    }
}

