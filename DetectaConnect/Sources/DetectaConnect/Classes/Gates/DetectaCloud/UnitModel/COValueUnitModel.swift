//
//  COValueUnitModel.swift
//  DetectaConnect
//
//  Created by Kanstantsin Bucha on 7.04.21.
//

import Foundation

class COValueUnitModel: UnitValueModel {
    let unit = UnitModel(title: "CO", unit: "ppm")
    let valuePath: KeyPath<CloudContextWrapper, Float>  = \.context.coPpm
    var value: String { String(format: "%.0f", valueNum) }
    var state: UnitValueState {
        switch valueNum {
        case 0...9:
            return .good
        case 10...20:
            return .warning
        case 21...40:
            return .danger
        default:
            return .alarm
        }
    }
    
    private var valueNum: Float = 0
    
    public init() {}
    
    func apply(value: Float) {
        valueNum = value > 0 ? value : 0
    }
}


