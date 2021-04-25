//
//  ValueUnitModel.swift
//  DetectaConnectSDK
//
//  Created by Kanstantsin Bucha on 4.04.21.
//

import Foundation

public enum ValueUnitState: Int {
    case good = 0
    case warning
    case danger
    case alarm
}

public protocol ValueUnitModel: class {
    var title: String { get }
    var unit: String { get }
    var value: String { get }
    var state: ValueUnitState { get }
    
    func update(value: Float)
}

public protocol CombinedValueUnitModel: ValueUnitModel {
    var valueState: ValueUnitState { get }
    func update(value: Float, models: [ValueUnitModel])
}
