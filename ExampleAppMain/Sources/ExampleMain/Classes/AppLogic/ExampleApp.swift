import SwiftUI

public class ExampleApp {
    @available(iOSApplicationExtension, unavailable)
    
    public static var assetsBundle: Bundle {
        return Bundle.module
    }
    
    public var contentView: some View {
        service(AppRouter.self).contentView
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { [weak self] _ in
                self?.applicationDidBecomeActive()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { [weak self] _ in
                self?.applicationWillEnterForeground()
            }
    }
    
    public static func initialize() -> ExampleApp {
        setupServices()
        service(GatesKeeper.self).summonAll()
        return ExampleApp()
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

