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
    
    private var valueNum: Float = 0
    
    func update(value: Float) {
        valueNum = value
    }
}
