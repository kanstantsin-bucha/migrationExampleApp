//
//  LocalContextPackage.swift
//  DetectaConnect
//
//  Created by Kanstantsin Bucha on 4.04.21.
//

import Foundation

public struct LocalContextPackage: Decodable {
    let id: String
    let deviceId: String
    let createdAt: Date
    let data: LocalContextValues
    
    public init(id: String, deviceId: String, createdAt: Date, data: LocalContextValues) {
        self.id = id
        self.deviceId = deviceId
        self.createdAt = createdAt
        self.data = data
    }
}

extension LocalContextPackage {
    var created: Date { createdAt }
}
