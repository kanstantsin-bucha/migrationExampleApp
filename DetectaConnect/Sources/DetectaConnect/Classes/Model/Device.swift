//
//  Device.swift
//  DetectaConnect
//
//  Created by Konstantin Bucha on 4/11/21.
//

import Foundation

public protocol Device: Codable {
    var id: String { get }
    var name: String { get }
    var token: String { get }
    var date: Date { get }
    
    mutating func update(name: String) -> Bool
}

public struct DefaultDevice: Device {
    public var id: String
    public var name: String
    public var token: String
    public var date: Date
    
    public mutating func update(name: String) -> Bool {
        guard self.name != name else { return false }
        self.name = name
        return true
    }
}
