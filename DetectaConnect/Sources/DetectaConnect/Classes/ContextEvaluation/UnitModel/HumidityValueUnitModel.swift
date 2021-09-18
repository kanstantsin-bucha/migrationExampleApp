//
//  HumidityValueUnitModel.swift
//  DetectaConnect
//
//  Created by Kanstantsin Bucha on 4.04.21.
//

import Foundation

class HumidityValueUnitModel: UnitValueModel {
    let unit = UnitModel(title: "Humidity", shortTitle: "H%", unit: "%")
    let valuePath: KeyPath<CloudContextWrapper, Float>  = \.context.humidity
    var value: String { String(format: "%.1f", valueNum) }
    var state: UnitValueState {
        switch valueNum {
        case 30...65:
            return .good
        case 25...80:
            return .warning
        case 20...90:
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
