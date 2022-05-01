//
//  EnvironmentRisksEvaluator.swift
//  
//
//  Created by Kanstantsin Bucha on 30/04/2022.
//

import Foundation

final class EnvironmentRisksEvaluator {
    public var configVersion: String { config.version }
    private var config: EnvironmentConfig
    
    public init() throws {
        let fileUrl = try URL(frameworkAssetName: "unit_models.json")
        let jsonData = try Data(contentsOf: fileUrl)
        let inAppConfig = try JSONDecoder().decode(EnvironmentConfig.self, from: jsonData)
        config = inAppConfig
        log.debug("created models: \(config.models.map { $0.shortTitle })")
    }
    
    public func updateModelFromCloud() {
        service(GatesKeeper.self).cloudGate.fetchEnvironmentConfig(currentVersion: configVersion)
            .onSuccess { [weak self] cloudConfigWrapper in
                guard let self = self else {
                    log.error("Lose context during fetch")
                    return
                }
                guard case let .newData(cloudConfig) = cloudConfigWrapper else {
                    log.debug("Cloud update: current config version \(self.configVersion) is up to date")
                    return
                }
                do {
                    try self.check(config: cloudConfig)
                    self.config = cloudConfig
                    log.debug("""
                        Cloud update: version: \(cloudConfig.version)
                        created models: \(cloudConfig.models.map { $0.shortTitle })
                        """
                    )
                } catch {
                    log.error("Cloud update: config check failed \(error)")
                }
            }
            .onFailure { error in
                log.error("Cloud update: fetch failed \(error)")
            }
    }
    
    public func createEvaluationGroup() -> EvaluationGroup {
        EvaluationGroup(model: config)
    }
    
    private func check(config: EnvironmentConfig) throws {
        guard config.models.count > 0, !config.version.isEmpty else {
            throw GenericError.invalidData
        }
    }
}
