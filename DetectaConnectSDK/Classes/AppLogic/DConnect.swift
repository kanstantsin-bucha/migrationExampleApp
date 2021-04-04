//
//  AppDelegate.swift
//  client
//
//  Created by Kanstantsin Bucha on 6/10/19.
//  Copyright © 2019 Detecta Group. All rights reserved.
//

import Foundation

public class DConnect {
    public static func initialise() -> UIViewController {
        setupServices()
        service(GatesKeeper.self).summonAll()
        return ViewFactory.loadView(id: View.root)
    }
    
    public static var resourcesBundle: Bundle {
        return Bundle(for: DConnect.self)
    }
}

