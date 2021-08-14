//
//  TemperatureValueUnitModel.swift
//  DetectaConnect
//
//  Created by Kanstantsin Bucha on 4.04.21.
//

import Foundation

class TemperatureValueUnitModel: UnitValueModel {
    let unit = UnitModel(title: "Temperature", shortTitle: "T", unit: "℃")
    let valuePath: KeyPath<CloudContextWrapper, Float>  = \.context.tempCelsius
    var value: String { String(format: "%.1f", valueNum) }
    var state: UnitValueState {
        switch valueNum {
        case 18...28:
            return .good
        case 10...36:
            return .warning
        case 4...55:
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
