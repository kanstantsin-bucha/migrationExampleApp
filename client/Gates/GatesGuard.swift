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
    var bleGate: GateKeeper { get }
}

protocol GateKeeper {
    
    var isOpen: Bool { get }
    
    func summon(
        infoDictionary: [String : Any]?,
        launchOptions: [AnyHashable : Any]?
    ) throws
    
    func open() throws
    func close()
}

class GatesKeeperImpl: GatesKeeper {
    static let shared: GatesKeeper = GatesKeeperImpl()
    
    let bleGate: GateKeeper = DefaultBleCoreGate()
    
    func summonAll(
        launchOptions: [AnyHashable : Any]?
    ) {
        
        let info = Bundle.main.infoDictionary
        do {
            try bleGate.summon(
                infoDictionary: info,
                launchOptions: launchOptions
            )
        }
        catch let error {
            print("\(error)")
        }
    }
}
