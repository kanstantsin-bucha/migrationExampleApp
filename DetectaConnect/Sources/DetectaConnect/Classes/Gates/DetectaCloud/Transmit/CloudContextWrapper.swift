//
//  CloudContextWrapper.swift
//  DetectaConnect
//
//  Created by Kanstantsin Bucha on 4.04.21.
//

import Foundation

public struct CloudContextWrapper: Decodable {
    let id: String
    let deviceId: String
    let createdAt: Date
    let data: CloudContextValues
}

extension CloudContextWrapper {
    var created: Date { createdAt }
}
