//
//  IAQValueUnitModel.swift
//  DetectaConnectSDK
//
//  Created by Konstantin on 4/25/21.
//

import Foundation

class IAQValueUnitModel: ValueUnitModel {
    var title: String { "IAQ" }
    var unit: String { "" }
    var value: String { String(format: "%.0f", valueNum) }
    var state: ValueUnitState {
        switch valueNum {
        case 0...99:
            return .good
        case 100...200:
            return .warning
        case 201...300:
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
