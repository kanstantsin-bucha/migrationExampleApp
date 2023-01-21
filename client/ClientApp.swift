//
//  ClientApp.swift
//  D-Connect
//
//  Created by Kanstantsin Bucha on 21/01/2023.
//  Copyright © 2023 Detecta Group. All rights reserved.
//

import DetectaConnect
import SwiftUI

@main
struct ClientApp: App {
    @State private var engine = DConnect.initialize()
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
