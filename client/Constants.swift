//
//  Constants.swift
//  client
//
//  Created by Kanstantsin Bucha on 5.03.21.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import Foundation

enum Constant {
    enum AppLink {
        static let supportUrl = URL(string: "http://detecta.group/support/")!
    }
    enum Notifications {
        enum ContextUpdate {
            static let name: NSNotification.Name = NSNotification.Name(rawValue: "Notifications.contextUpdate")
            static let values = "values"
        }
    }
    enum Ble {
        enum Commands {
            static let uuid = "652ab12e-e7ed-4e8e-a5dd-c5583692381f"
            enum Tx {
                static let uuid = "c166dc49-284e-4041-800d-53d27d14d0a9"
            }
            enum Rx {
                static let uuid = "4cc36fe5-d565-49ce-8550-8b51f098b761"
            }
        }
    }
    enum View {
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
                enum Segue {
                    static let showPreferences = "showPreferences"
                }
            }
            enum Suport {
                static let id = "support"
            }
            enum Values {
                static let id = "values"
            }
        }
    }
}
