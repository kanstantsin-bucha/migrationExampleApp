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
        let precision = unit.floatPrecision ?? 0
        value = String(format: "%.\(precision)f", unitValue)
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
        let version = service(EnvironmentRisksEvaluator.self).configVersion
        log.error("Evaluation failed for unit \(unit.title) at \(version)")
        return .alarm
    }
    
    private func evaluate(value: Float, stateLogic: UnitStateLogic) -> Bool {
        guard stateLogic.enabled else {
            return false
        }
        guard let range = stateLogic.range else {
            return true
        }
        return range.range.contains(value)
    }
}
