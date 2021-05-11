//
//  PressureValueUnitModel.swift
//  DetectaConnectSDK
//
//  Created by Kanstantsin Bucha on 7.04.21.
//

import Foundation

class PressureValueUnitModel: UnitValueModel {
    let unit = UnitModel(title: "Pressure", unit: "hPa")
    let valuePath: KeyPath<CloudContextWrapper, Float>  = \.context.pressurePa
    var value: String { String(format: "%.0f", valueNum) }
    var state: UnitValueState {
        switch valueNum {
        case 940...1020:
            return .good
        case 920...1040:
            return .warning
        case 900...1060:
            return .danger
        default:
            return .alarm
        }
    }
    
    private var valueNum: Float = 0
    
    public init() {}
    
    func apply(value: Float) {
        valueNum = value / 100
    }
}
