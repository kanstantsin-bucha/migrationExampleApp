import Foundation

enum ViewType {
    static let root = "RootNavigation"
    enum Group {
    }
    enum a {
        enum SetupGadget {
            static let id = "SetupGadget"
        }
        enum Preferences {
            static let id = "preferences"
            enum SegueId {
                static let showPreferences = "showPreferences"
            }
        }
        enum Suport {
            static let id = "support"
        }
        enum Values {
            static let id = "values"
        }
        enum Context {
            static let id = "ContextViewController"
        }
        enum TimeSpan {
            static let id = "TimeSpanViewController"
        }
        enum DeviceSettings {
            static let id = "DeviceSettingsViewController"
        }
        enum Home {
            static let id = "HomeViewController"
            enum SegueId {
                static let toContext = "HomeToContext"
            }
        }
    }
}
