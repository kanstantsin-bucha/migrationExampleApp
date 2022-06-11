//
//  File.swift
//  
//
//  Created by Kanstantsin Bucha on 11/06/2022.
//

import Foundation
import UserNotifications
import UIKit

public final class PushNotificationsGate: NSObject {
    func handle(deviceToken: Data) {
        guard service(GatesKeeper.self).cloudGate.isOpen else {
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(5 * 60)) { [weak self] in
                self?.handle(deviceToken: deviceToken)
            }
            return
        }
        let token = deviceToken.hexEncodedString()
        log.event("Got device token for notifications: \(token)")
    }
    
    func handleFailToRegister(error: Error) {
        log.error("Failed to register for push notifications: \(error)")
    }
}

extension PushNotificationsGate: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        log.event("Got notification: \(notification.request)")
        return [.banner, .sound, .badge]
    }
}

extension PushNotificationsGate: GateKeeper {
    var isOpen: Bool { true }
    
    func summon() {
        UNUserNotificationCenter.current().delegate = self
    }
    
    func open() {
        Task {
            do {
                try await UNUserNotificationCenter.current().requestAuthorization(
                    options: [.alert, .badge, .sound]
                )
                await UIApplication.shared.registerForRemoteNotifications()
                log.event("App requested a registeration for remote notifications")
            } catch {
                log.error("Failed to request authorisation for push notifications: \(error)")
            }
        }
    }
    
    func close() {}
}
