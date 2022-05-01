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
        converter: ResponseConverter<CloudContext> = ResponseConverter()
    ) -> Future<CloudResponseWrapper<CloudContext>> {
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
            .addItem(name: cloud.Query.currentVersion, value: currentVersion)
            .url()
        return service(NetworkService.self).load(
            url: url,
            converter: converter
        )
    }
    
    public func fetchIntervalContext(
        token: String,
        startDate: Date,
        interval: FetchInterval,
        converter: ResponseConverter<CloudContext> = ResponseConverter()
    ) -> Future<CloudResponseWrapper<CloudContext>> {
        return service(NetworkService.self).load(
            url: intervalContext(
                token: token,
                startDate: startDate,
                endDate: startDate.addingTimeInterval(interval.rawValue)
            ),
            converter: converter
        )
    }
    
    // MARK: - Private methods
    
    private func lastContext(token: String) -> URL {
        cloudBuilder
            .addPath(path: cloud.Endpoint.measurements)
            .addItem(name: "uid", value: token)
            .addQuery(name: cloud.Query.limit, value: 1)
            .addQuery(name: cloud.Query.sort, params: cloud.Field.createdAt, value: cloud.Order.descending)
            .url()
    }
    
    private func intervalContext(
        token: String,
        startDate: Date,
        endDate: Date
    ) -> URL {
        let start = UInt(startDate.timeIntervalSince1970)
        let end = UInt(endDate.timeIntervalSince1970)
        return cloudBuilder
            .addPath(path: cloud.Endpoint.measurements)
            .addItem(name: "uid", value: token)
            .addQuery(name: cloud.Field.createdAt, params: cloud.Query.greaterThanOrEqual, value: start)
            .addQuery(name: cloud.Field.createdAt, params: cloud.Query.lessThanOrEqual, value: end)
            .addQuery(name: cloud.Query.limit, value: fetchLimit)
            .addQuery(name: cloud.Query.sort, params: cloud.Field.createdAt, value: cloud.Order.ascending)
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
