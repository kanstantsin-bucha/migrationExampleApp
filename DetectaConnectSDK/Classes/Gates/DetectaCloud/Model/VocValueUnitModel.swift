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
    
    private var valueNum: Float = 0
    
    func update(value: Float) {
        valueNum = value
    }
}
