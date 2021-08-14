//
//  NavigationController+.swift
//  BlueSwift
//
//  Created by Konstantin on 5/8/21.
//

import UIKit

class NavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        }
        return .default
    }
}
