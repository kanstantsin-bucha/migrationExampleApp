//
//  AppDelegate.swift
//  client
//
//  Created by Kanstantsin Bucha on 6/10/19.
//  Copyright © 2019 Detecta Group. All rights reserved.
//

import UIKit
import Sentry

public class DConnect {
    @available(iOSApplicationExtension, unavailable)
    public static func initialize() -> UIViewController {
        SentrySDK.start { options in
            options.dsn = "https://bf1536e15da64ef1b3eae67383d8e868@o1153823.ingest.sentry.io/6244980"
            options.debug = true
        }
        SentrySDK.capture(message: "App launched")
        
        setupServices()
        setupAppearance()
        service(GatesKeeper.self).summonAll()
        let controller = ViewFactory.loadView(id: View.root)
        (controller as? UINavigationController)?.navigationBar.barStyle = .black
        return controller
    }
    
    public static var resourcesBundle: Bundle {
        return Bundle.module
    }
    
    // MARK: - Private methods
    
    private static func setupAppearance() {
        let titleColor = UIColor.frameworkAsset(named: "AirGray_K30")
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: titleColor,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
        ]
    }
}

