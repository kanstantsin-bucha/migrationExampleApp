//
//  CrashlyticsIntegration.swift
//  QromaTagMac
//
//  Created by Kanstantsin Bucha on 2/21/18.
//  Copyright © 2019 Detecta Group LLC. All rights reserved.
//

import Foundation

class CrashlyticsGate: GateKeeper {
    
    let isOpen = false
    
    func summon(
        infoDictionary: [String : Any]?,
        launchOptions: [AnyHashable : Any]?
    ) throws {
    
//        let defaults = ["NSApplicationCrashOnExceptions": true]
//        UserDefaults.standard.register(defaults: defaults)
        
//        Fabric.with([Crashlytics.self])
    }
    
    func open() throws {
    }
    
    func close() {
    }
}
