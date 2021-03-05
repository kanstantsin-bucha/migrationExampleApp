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
        let result = UIStoryboard(name: "Views", bundle: nil)
        return result
    }
    
    //MARK: - logic -
    
    static func loadView(id: String) -> UIViewController {
        return viewTypes.instantiateViewController(withIdentifier: id)
    }
}
