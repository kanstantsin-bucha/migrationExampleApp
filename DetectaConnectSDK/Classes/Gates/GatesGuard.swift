//
//  integrations.swift
//  Client iOS
//
//  Created by Kanstantsin Bucha on 8/1/18.
//  Copyright © 2019 Detecta Group. All rights reserved.
//

import Foundation

protocol GatesKeeper {
    func summonAll()
    var bleGate: GateKeeper & BleTransmitter { get }
}

protocol GateKeeper {
    var isOpen: Bool { get }
    
    func summon()
    func open()
    func close()
}

class DefaultGatesKeeper: GatesKeeper {
    let bleGate: GateKeeper & BleTransmitter = BleGate()
    
    func summonAll() {
        bleGate.summon()
    }
}
