//
//  IAQValueUnitModel.swift
//  DetectaConnect
//
//  Created by Konstantin on 4/25/21.
//

import Foundation

class IAQValueUnitModel: UnitValueModel {
    let unit = UnitModel(title: "IAQ", unit: "")
    let valuePath: KeyPath<CloudContextWrapper, Float>  = \.context.iaq
    var value: String { String(format: "%.0f", valueNum) }
    var state: UnitValueState {
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
    
    func apply(value: Float) {
        valueNum = value
    }
}
