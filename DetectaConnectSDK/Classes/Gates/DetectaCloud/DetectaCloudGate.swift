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
    private let converter = DetectaCloudResponseConverter()
    private var cloudBuilder: ApiUrlBuilder { ApiUrlBuilder(c.Endpoint.cloudServer) }
    
    public init() {}
    
    public func fetchLastContext() -> Future<CloudContext> {
        return service(NetworkService.self).load(url: lastContext(), converter: converter)
    }
    
    private func lastContext() -> URL {
        cloudBuilder
            .addPath(path: c.Endpoint.measurements)
            .addQuery(name: c.Query.limit, value: 1)
            .addQuery(name: c.Query.sort, field: c.Field.createdAt, value: c.Order.descending)
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
