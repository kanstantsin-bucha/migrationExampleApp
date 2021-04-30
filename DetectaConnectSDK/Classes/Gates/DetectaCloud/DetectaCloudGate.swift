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
    
    var spanCount: Int {
        switch self {
        case .oneHour:
            return 6
        
        case .eightHours:
            return 8
            
        case .oneDay:
            return 6
        }
    }
    
    var normalizationCoefficient: Double {
        switch self {
        case .oneHour:
            return 1 / 3600
        
        case .eightHours:
            return 1 / 3600
            
        case .oneDay:
            return 1 / 60
        }
    }
}

public class DetectaCloudGate {
    // on the D-Cloud there is the deflator logic that sends only representative results of count 50
    private let fetchLimit = 50
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
            .addQuery(name: c.Query.sort, params: c.Field.createdAt, value: c.Order.descending)
            .url()
    }
    
    private func periodContext(
        token: String,
        startDate: Date,
        endDate: Date
    ) -> URL {
        let start = UInt(startDate.timeIntervalSince1970)
        let end = UInt(endDate.timeIntervalSince1970)
        return cloudBuilder
            .addPath(path: c.Endpoint.measurements)
            .addItem(name: "uid", value: token)
            .addQuery(name: c.Field.createdAt, params: c.Query.greaterThanOrEqual, value: start)
            .addQuery(name: c.Field.createdAt, params: c.Query.lessThanOrEqual, value: end)
            .addQuery(name: c.Query.limit, value: fetchLimit)
            .addQuery(name: c.Query.sort, params: c.Field.createdAt, value: c.Order.ascending)
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
