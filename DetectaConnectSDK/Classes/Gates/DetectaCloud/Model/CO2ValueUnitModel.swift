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
    
    private var valueNum: Float = 0
    
    func update(value: Float) {
        valueNum = value
    }
}
