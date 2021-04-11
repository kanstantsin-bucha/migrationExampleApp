//
//  Views.swift
//  DetectaConnectSDK
//
//  Created by Kanstantsin Bucha on 4.04.21.
//

import Foundation

enum View {
    static let root = "rootNavigation"
    enum Group {
        enum Guide {
            enum WiFi {
                static let id = "wifi-guide"
            }
        }
    }
    enum a {
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
        enum Home {
            enum SegueId {
                static let toContext = "HomeToContext"
            }
        }
    }
}
