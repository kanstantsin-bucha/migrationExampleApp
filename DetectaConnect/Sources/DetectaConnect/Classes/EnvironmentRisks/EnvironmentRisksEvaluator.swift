//
//  EnvironmentRisksEvaluator.swift
//  
//
//  Created by Kanstantsin Bucha on 30/04/2022.
//

import Foundation

final class EnvironmentRisksEvaluator {
    private var model: UnitsModel
    
    public init() throws {
        let fileUrl = try URL(frameworkAssetName: "unit_models.json")
        let jsonData = try Data(contentsOf: fileUrl)
        model = try Self.createModel(jsonData: jsonData)
        log.debug("created models: \(model.models.map { $0.shortTitle })")
    }
    
    public static func createModel(jsonData: Data) throws -> UnitsModel {
        let incomingModel = try JSONDecoder().decode(UnitsModel.self, from: jsonData)
        guard incomingModel.models.count > 0 else {
            throw GenericError.invalidData
        }
        return incomingModel
    }
    
    public func updateModel(jsonData: Data) throws {
        model = try Self.createModel(jsonData: jsonData)
    }
    
    public func createEvaluationGroup() -> EvaluationGroup {
        EvaluationGroup(model: model)
    }
}
