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
    
    func apply(unitValue: Float) {
        value = String(format: "%.0f", unitValue)
        state = evaluate(value: unitValue)
    }
    
    // MARK: - Private methods
    
    private func evaluate(value: Float) -> UnitValueState {
        if evaluate(value: value, stateLogic: unit.good) {
            return .good
        }
        if evaluate(value: value, stateLogic: unit.warning) {
            return .warning
        }
        if evaluate(value: value, stateLogic: unit.danger) {
            return .danger
        }
        if evaluate(value: value, stateLogic: unit.alarm) {
            return .alarm
        }
        return .alarm
    }
    
    private func evaluate(value: Float, stateLogic: UnitStateLogic) -> Bool {
        guard stateLogic.enabled else {
            return false
        }
        guard let ranges = stateLogic.ranges else {
            return true
        }
        guard ranges.contains(where: { $0.range.contains(value) }) else {
            return false
        }
        return true
    }
}
