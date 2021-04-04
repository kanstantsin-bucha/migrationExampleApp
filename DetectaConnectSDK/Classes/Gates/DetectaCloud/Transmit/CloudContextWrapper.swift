//
//  CloudContextWrapper.swift
//  DetectaConnectSDK
//
//  Created by Kanstantsin Bucha on 4.04.21.
//

import Foundation

public struct CloudContextWrapper: Decodable {
    let _id: String
    let timestamp: Int
    let token: String
    let context: CloudContextValues
}
