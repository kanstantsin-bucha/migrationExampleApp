//
//  Device.swift
//  DetectaConnectSDK
//
//  Created by Konstantin Bucha on 4/11/21.
//

import Foundation

protocol Device: Codable {
    var id: String { get }
    var name: String { get }
    var token: String { get }
    
    mutating func update(name: String)
}

struct DefaultDevice: Device {
    var id: String
    var name: String
    var token: String
    
    mutating func update(name: String) {
        self.name = name
    }
}
