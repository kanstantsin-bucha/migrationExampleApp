//
//  CO2ValueUnitModel.swift
//  DetectaConnectSDK
//
//  Created by Kanstantsin Bucha on 7.04.21.
//

import Foundation

class CO2ValueUnitModel: ValueUnitModel {
    var title: String { "CO2" }
    var unit: String { "ppm" }
    var value: String { String(format: "%.0f", valueNum) }
    var state: ValueUnitState {
        switch valueNum {
        case 0...800:
            return .good
        case 800...1200:
            return .warning
        case 1200...2000:
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
