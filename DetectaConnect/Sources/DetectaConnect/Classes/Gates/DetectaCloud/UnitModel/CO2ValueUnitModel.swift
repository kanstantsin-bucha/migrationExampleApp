//
//  CO2ValueUnitModel.swift
//  DetectaConnect
//
//  Created by Kanstantsin Bucha on 7.04.21.
//

import Foundation

class CO2ValueUnitModel: UnitValueModel {
    let unit = UnitModel(title: "CO\u{2082}", unit: "ppm")
    let valuePath: KeyPath<CloudContextWrapper, Float>  = \.context.co2Equivalent
    var value: String { String(format: "%.0f", valueNum) }
    var state: UnitValueState {
        switch valueNum {
        case 0..<800:
            return .good
        case 800..<1500:
            return .warning
        case 1500..<2000:
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
