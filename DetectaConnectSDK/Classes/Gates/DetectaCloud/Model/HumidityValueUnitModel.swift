//
//  HumidityValueUnitModel.swift
//  DetectaConnectSDK
//
//  Created by Kanstantsin Bucha on 4.04.21.
//

import Foundation

class HumidityValueUnitModel: ValueUnitModel {
    var title: String { "Humidity" }
    var unit: String { "%" }
    var value: String { String(format: "%.1f", valueNum) }
    var state: ValueUnitState {
        switch valueNum {
        case 40...60:
            return .good
        case 30...70:
            return .warning
        case 25...75:
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
