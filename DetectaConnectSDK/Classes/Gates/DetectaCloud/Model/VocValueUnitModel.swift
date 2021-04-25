//
//  VocValueUnitModel.swift
//  DetectaConnectSDK
//
//  Created by Kanstantsin Bucha on 7.04.21.
//

import Foundation

class VocValueUnitModel: ValueUnitModel {
    var title: String { "VOC" }
    var unit: String { "ppm" }
    var value: String { String(format: "%.0f", valueNum) }
    var state: ValueUnitState {
        switch valueNum {
        case 0...1:
            return .good
        case 1...3:
            return .warning
        case 3...10:
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
