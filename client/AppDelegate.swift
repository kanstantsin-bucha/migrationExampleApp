import ExampleMain
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    var engine: ExampleApp?
    
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

