//
//  CloudContextWrapper.swift
//  DetectaConnect
//
//  Created by Kanstantsin Bucha on 4.04.21.
//

import Foundation

public struct CloudContextWrapper: Decodable {
    let _id: String
    let millis: Int
    let uid: String
    let createdAt: TimeInterval
    let context: CloudContextValues
}

extension CloudContextWrapper {
    var created: Date { Date(timeIntervalSince1970: createdAt) }
}
