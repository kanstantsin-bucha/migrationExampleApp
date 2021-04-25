//
//  IAQValueUnitModel.swift
//  DetectaConnectSDK
//
//  Created by Konstantin on 4/25/21.
//

import Foundation

class IAQValueUnitModel: CombinedValueUnitModel {
    var title: String { "IAQ" }
    var unit: String { "" }
    var value: String { String(format: "%.0f", valueNum) }
    var state = ValueUnitState.good
    var valueState: ValueUnitState {
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
        update(value: value, models: [])
    }
    
    func update(value: Float, models: [ValueUnitModel]) {
        valueNum = value
        var combined = valueState
        models.forEach { if $0.state.rawValue > combined.rawValue { combined = $0.state } }
        state = combined
    }
}
