//
//  DetectaCloudGate.swift
//  DetectaConnect
//
//  Created by Kanstantsin Bucha on 29.03.21.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import Foundation

fileprivate typealias cloud = DetectaCloud

public class DetectaCloudGate {
    // on the D-Cloud there is the deflator logic that sends only representative results of count 50
    // this limit is the limit of fetch results of the search query on the server
    private let fetchLimit = 2000
    private var cloudBuilder: ApiUrlBuilder { ApiUrlBuilder(cloud.Endpoint.cloudServer) }
    
    public init() {}
    
    public func fetchLastContext(
        token: String,
        converter: ResponseConverter<LocalContextPackage> = ResponseConverter()
    ) -> Future<CloudResponseWrapper<LocalContextPackage>> {
        return service(NetworkService.self).load(
            url: lastContext(token: token),
            converter: converter
        )
    }
    
    public func fetchEnvironmentConfig(
        currentVersion: String,
        converter: ResponseConverter<EnvironmentConfig> = ResponseConverter()
    ) -> Future<CloudResponseWrapper<EnvironmentConfig>> {
        let url = cloudBuilder
            .addPath(path: cloud.Endpoint.environment)
            .addItem(name: cloud.Query.deviceVersion, value: currentVersion)
            .addItem(name: cloud.Query.type, value: "d-air")
            .addItem(name: cloud.Query.deviceId, value: service(DevicePersistence.self).deviceId)
            .url()
        return service(NetworkService.self).load(
            url: url,
            converter: converter
        )
    }
    
    public func fetchIntervalContext(
        token: String,
        interval: FetchInterval,
        converter: ResponseConverter<[LocalContextPackage]> = ResponseConverter()
    ) -> Future<CloudResponseWrapper<[LocalContextPackage]>> {
        return service(NetworkService.self).load(
            url: intervalContext(
                token: token,
                lastHoursCount: interval.rawValue
            ),
            converter: converter
        )
    }
    
    // MARK: - Private methods
    
    private func lastContext(token: String) -> URL {
        cloudBuilder
            .addPath(path: cloud.Endpoint.measurements)
            .addPath(path: cloud.Path.latestWithDevice)
            .addPath(path: token)
            .url()
    }
    
    private func intervalContext(
        token: String,
        lastHoursCount: UInt
    ) -> URL {
        return cloudBuilder
            .addPath(path: cloud.Endpoint.measurements)
            .addPath(path: cloud.Path.interval)
            .addPath(path: token)
            .addItem(name: cloud.Query.lastHoursCount, value: lastHoursCount)
            .url()
    }
}

extension DetectaCloudGate: GateKeeper {
    var isOpen: Bool { true }
    
    func summon() {
        // not used
    }
    
    func open() {
        // not applicable
    }
    
    func close() {
        // not applicable
    }
}
