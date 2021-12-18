//
//  VocValueUnitModel.swift
//  DetectaConnect
//
//  Created by Kanstantsin Bucha on 7.04.21.
//

import Foundation

class VocValueUnitModel: UnitValueModel {
    let unit = UnitModel(title: "VOC", unit: "ppm")
    let valuePath: KeyPath<CloudContextWrapper, Float>  = \.context.breathVocEquivalent
    var value: String { String(format: "%.0f", valueNum) }
    var state: UnitValueState {
        switch valueNum {
        case 0..<2:
            return .good
        case 1..<5:
            return .warning
        case 5..<10:
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
