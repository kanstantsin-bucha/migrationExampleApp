//
//  CloudQueryResult.swift
//  DetectaConnectSDK
//
//  Created by Kanstantsin Bucha on 4.04.21.
//

import Foundation

public typealias CloudContext = CloudQueryResult<CloudContextWrapper>

public struct CloudQueryResult<T: Decodable>: Decodable {
    let total: Int
    let limit: Int
    let skip: Int
    let data: [T]
    
    public init(total: Int, limit: Int, skip: Int, data: [T]) {
        self.total = total
        self.limit = limit
        self.skip = skip
        self.data = data
    }
}
