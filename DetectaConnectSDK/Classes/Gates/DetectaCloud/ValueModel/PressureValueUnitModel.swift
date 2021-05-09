//
//  PressureValueUnitModel.swift
//  DetectaConnectSDK
//
//  Created by Kanstantsin Bucha on 7.04.21.
//

import Foundation

class PressureValueUnitModel: ValueUnitModel {
    var title: String { "Pressure" }
    var unit: String { "kPa" }
    var value: String { String(format: "%.2f", valueNum) }
    var state: ValueUnitState {
        switch valueNum {
        case 94...102:
            return .good
        case 92...104:
            return .warning
        case 90...106:
            return .danger
        default:
            return .alarm
        }
    }
    
    private var valueNum: Float = 0
    
    public init() {}
    
    func update(value: Float) {
        valueNum = value / 1000
    }
}
