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
    
    private var valueNum: Float = 0
    
    func update(value: Float) {
        valueNum = value
    }
}
