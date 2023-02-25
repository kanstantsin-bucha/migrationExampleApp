import ExampleMain
import SwiftUI

@main
struct ClientApp: App {
    @State private var engine = ExampleApp.initialize()
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    var body: some Scene {
        WindowGroup {
            engine.contentView
                .task {
                    appDelegate.engine = engine
                }
        }
    }
}
