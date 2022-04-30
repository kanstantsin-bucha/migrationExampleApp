//
//  ViewControllerFactory.swift
//  Client iOS
//
//  Created by Kanstantsin Bucha on 8/8/18.
//  Copyright © 2019 Detecta Group. All rights reserved.
//

import Foundation
import UIKit

class ViewFactory {
    static var viewTypes: UIStoryboard {
        let result = UIStoryboard(name: "Views", bundle: DConnect.assetsBundle)
        return result
    }
    
    //MARK: - logic -
    
    static func loadView(id: String) -> UIViewController {
        let view = viewTypes.instantiateViewController(withIdentifier: id)
        return view
    }
    
    static func loadView(nibName: String, owner: UIView) -> UIView {
        let nib = UINib(nibName: nibName, bundle: DConnect.assetsBundle)
        guard let view = nib.instantiate(withOwner: owner, options: nil).first as? UIView else {
            preconditionFailure("Failed to load view: \(nibName), owner: \(owner)")
        }
        return view
    }
}
