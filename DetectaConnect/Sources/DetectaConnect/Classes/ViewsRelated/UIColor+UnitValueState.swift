//
//  UIColor+ValueState.swift
//  DetectaConnect
//
//  Created by Konstantin on 5/10/21.
//

import UIKit

extension UIColor {
    static func with(state: UnitValueState) -> UIColor {
        switch state {
        case .good:
            return .frameworkAsset(named: "AirBlue")
            
        case .warning:
            return .frameworkAsset(named: "AirYellow")
            
        case .danger:
            return .frameworkAsset(named: "AirOrange")
            
        case .alarm:
            return .frameworkAsset(named: "AirRed")
        }
    }
}
