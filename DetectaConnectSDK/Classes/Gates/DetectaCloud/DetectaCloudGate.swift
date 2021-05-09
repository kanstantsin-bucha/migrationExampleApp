//
//  DetectaCloudGate.swift
//  DetectaConnect
//
//  Created by Kanstantsin Bucha on 29.03.21.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import Foundation

fileprivate typealias c = DetectaCloud

public class DetectaCloudGate {
    // on the D-Cloud there is the deflator logic that sends only representative results of count 50
    // this limit is the limit of fetch results of the search query on the server
    private let fetchLimit = 2000
    private let converter = DetectaCloudResponseConverter()
    private var cloudBuilder: ApiUrlBuilder { ApiUrlBuilder(c.Endpoint.cloudServer) }
    
    public init() {}
    
    public func fetchLastContext(token: String) -> Future<CloudContext> {
        return service(NetworkService.self).load(
            url: lastContext(token: token),
            converter: converter
        )
    }
    
    public func fetchIntervalContext(
        token: String,
        startDate: Date,
        interval: FetchInterval
    ) -> Future<CloudContext> {
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
            .addPath(path: c.Endpoint.measurements)
            .addItem(name: "uid", value: token)
            .addQuery(name: c.Query.limit, value: 1)
            .addQuery(name: c.Query.sort, params: c.Field.createdAt, value: c.Order.descending)
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
