//
//  TemperatureValueUnitModel.swift
//  DetectaConnectSDK
//
//  Created by Kanstantsin Bucha on 4.04.21.
//

import Foundation

class TemperatureValueUnitModel: ValueUnitModel {
    var title: String { "Temperature" }
    var unit: String { "℃" }
    var value: String { String(format: "%.1f", valueNum) }
    var state: ValueUnitState {
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
    
    func update(value: Float) {
        valueNum = value
    }
}
