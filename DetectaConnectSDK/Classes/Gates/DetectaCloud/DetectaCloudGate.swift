//
//  DetectaCloudGate.swift
//  DetectaConnect
//
//  Created by Kanstantsin Bucha on 29.03.21.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import Foundation

fileprivate typealias c = DetectaCloud

public enum FetchPeriod: TimeInterval {
    case oneHour = 3600
    case eightHours = 28800
    case oneDay = 86400
}

public class DetectaCloudGate {
    private let fetchLimit = 1440
    private let converter = DetectaCloudResponseConverter()
    private var cloudBuilder: ApiUrlBuilder { ApiUrlBuilder(c.Endpoint.cloudServer) }
    
    public init() {}
    
    public func fetchLastContext(token: String) -> Future<CloudContext> {
        return service(NetworkService.self).load(
            url: lastContext(token: token),
            converter: converter
        )
    }
    
    public func fetchPeriodContext(
        token: String,
        endDate: Date,
        period: FetchPeriod
    ) -> Future<CloudContext> {
        return service(NetworkService.self).load(
            url: periodContext(
                token: token,
                startDate: endDate.addingTimeInterval(-period.rawValue),
                endDate: endDate
            ),
            converter: converter
        )
    }
    
    private func lastContext(token: String) -> URL {
        cloudBuilder
            .addPath(path: c.Endpoint.measurements)
            .addItem(name: "uid", value: token)
            .addQuery(name: c.Query.limit, value: 1)
            .addQuery(name: c.Query.sort, field: c.Field.createdAt, value: c.Order.descending)
            .url()
    }
    
    private func periodContext(
        token: String,
        startDate: Date,
        endDate: Date
    ) -> URL {
        cloudBuilder
            .addPath(path: c.Endpoint.measurements)
            .addItem(name: "uid", value: token)
            .addQuery(name: c.Query.greaterThanOrEqual, value: startDate)
            .addQuery(name: c.Query.lessThanOrEqual, value: endDate)
            .addQuery(name: c.Query.limit, value: fetchLimit)
            .addQuery(name: c.Query.sort, field: c.Field.createdAt, value: c.Order.ascending)
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
