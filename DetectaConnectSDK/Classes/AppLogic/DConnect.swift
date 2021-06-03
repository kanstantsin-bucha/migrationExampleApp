//
//  AppDelegate.swift
//  client
//
//  Created by Kanstantsin Bucha on 6/10/19.
//  Copyright © 2019 Detecta Group. All rights reserved.
//

import Foundation

public class DConnect {
    public static func initialize() -> UIViewController {
        setupServices()
        setupAppearance()
        service(GatesKeeper.self).summonAll()
        let controller = ViewFactory.loadView(id: View.root)
        (controller as? UINavigationController)?.navigationBar.barStyle = .black
        return controller
    }
    
    public static var resourcesBundle: Bundle {
        return Bundle(for: DConnect.self)
    }
    
    // MARK: - Private methods
    
    private static func setupAppearance() {
        let titleColor = UIColor.frameworkAsset(named: "AirBlue")
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: titleColor,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
        ]
    }
}

