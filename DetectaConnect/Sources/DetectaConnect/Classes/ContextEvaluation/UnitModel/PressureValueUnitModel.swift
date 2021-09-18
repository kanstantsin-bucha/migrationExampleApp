//
//  PressureValueUnitModel.swift
//  DetectaConnect
//
//  Created by Kanstantsin Bucha on 7.04.21.
//

import Foundation

class PressureValueUnitModel: UnitValueModel {
    let unit = UnitModel(title: "Pressure", shortTitle: "P", unit: "hPa")
    let valuePath: KeyPath<CloudContextWrapper, Float>  = \.context.pressureHPa
    var value: String { String(format: "%.0f", valueNum) }
    var state: UnitValueState {
        switch valueNum {
        case 980...1030:
            return .good
        case 790...1215:
            return .warning
        case 650...1417:
            return .danger
        default:
            return .alarm
        }
    }
    
    private var valueNum: Float = 0
    
    public init() {}
    
    func apply(value: Float) {
        valueNum = value
    }
}
