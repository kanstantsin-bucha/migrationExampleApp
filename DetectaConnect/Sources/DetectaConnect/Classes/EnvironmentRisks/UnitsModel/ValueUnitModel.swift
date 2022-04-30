//
//  UnitValueModel.swift
//  DetectaConnect
//
//  Created by Kanstantsin Bucha on 4.04.21.
//

import Foundation

class ValueUnitModel {
    let unit: UnitModel
    private(set) var value = ""
    private(set) var state: UnitValueState = .good
    
    init(unit: UnitModel) {
        self.unit = unit
    }
    
    func apply(contextWrapper: CloudContextWrapper) {
        apply(unitValue: contextWrapper.context[unit.contextKey])
    }
    
    func apply(unitValue: Float) {
        value = String(format: "%.0f", unitValue)
        #warning("TODO: implement state")
        state = .alarm
    }
}
