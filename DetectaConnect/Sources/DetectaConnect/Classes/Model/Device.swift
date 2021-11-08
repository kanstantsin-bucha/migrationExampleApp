//
//  Device.swift
//  DetectaConnect
//
//  Created by Konstantin Bucha on 4/11/21.
//

import Foundation

public struct Device: Codable {
    public var id: String
    public var name: String
    public var token: String
    public var date: Date
    
   public init(id: String,
         name: String,
         token: String,
         date: Date) {
        self.id = id
        self.name = name
        self.token = token
        self.date = date
    }
    
    public mutating func update(name: String) -> Bool {
        guard self.name != name else { return false }
        self.name = name
        return true
    }
}
