//
//  File.swift
//  
//
//  Created by Kanstantsin Bucha on 30/04/2022.
//

import Foundation

public typealias ContextValueExtractor = (CloudContextValues) -> Float

final class EvaluationGroup {
    let valueModels: [ValueUnitModel]
    
    init(model: EnvironmentConfig) {
        valueModels = model.models.map { ValueUnitModel(unit: $0) }
    }
    
    func makeValueExtractor(model: ValueUnitModel) -> ContextValueExtractor {
        return { $0[model.unit.contextKey] ?? 0 }
    }
    
    func apply(context: CloudContextValues) {
        valueModels.forEach { model in
            let key = model.unit.contextKey
            guard let value = context[model.unit.contextKey] else {
                log.error("Failed to get value for \(model.unit.title), \(key)")
                return
            }
            model.apply(unitValue: value)
        }
    }
}
