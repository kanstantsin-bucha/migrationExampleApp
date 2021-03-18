//
//  integrations.swift
//  Client iOS
//
//  Created by Kanstantsin Bucha on 8/1/18.
//  Copyright © 2019 Detecta Group. All rights reserved.
//

import Foundation

protocol GatesKeeper {
    func summonAll(launchOptions: [AnyHashable : Any]?)
    var bleGate: GateKeeper & BleTransmitter { get }
}

protocol GateKeeper {
    
    var isOpen: Bool { get }
    
    func summon(
        infoDictionary: [String : Any]?,
        launchOptions: [AnyHashable : Any]?
    )
    
    func open()
    func close()
}

class DefaultGatesKeeper: GatesKeeper {
    let bleGate: GateKeeper & BleTransmitter = DefaultBleCoreGate()
    
    func summonAll(
        launchOptions: [AnyHashable : Any]?
    ) {
        
        let info = Bundle.main.infoDictionary

        bleGate.summon(
            infoDictionary: info,
            launchOptions: launchOptions
        )
    }
}
