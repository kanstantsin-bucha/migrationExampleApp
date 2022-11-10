//
//  CALayer+Border.swift
//  
//
//  Created by Kanstantsin Bucha on 10/11/2022.
//

import UIKit

extension CALayer {
    @objc var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.cgColor
        }
    
        get {
            return UIColor(cgColor: self.borderColor!)
        }
    }
}
