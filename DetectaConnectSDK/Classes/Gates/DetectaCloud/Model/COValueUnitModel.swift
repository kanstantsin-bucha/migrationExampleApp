//
//  COValueUnitModel.swift
//  DetectaConnectSDK
//
//  Created by Kanstantsin Bucha on 7.04.21.
//

import Foundation

class COValueUnitModel: ValueUnitModel {
    var title: String { "CO" }
    var unit: String { "ppm" }
    var value: String { String(format: "%.0f", valueNum) }
    var state: ValueUnitState {
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
    
    func update(value: Float) {
        valueNum = value > 0 ? value : 0
    }
}


