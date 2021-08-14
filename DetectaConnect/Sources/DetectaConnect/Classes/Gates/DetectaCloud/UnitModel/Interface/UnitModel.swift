//
//  UnitModel.swift
//  DetectaConnect
//
//  Created by Konstantin on 5/10/21.
//

import Foundation

public struct UnitModel: Equatable {
    public var uuid: UUID = UUID()
    public var title: String
    public var shortTitle: String
    public var unit: String
    
    public init(title: String, shortTitle: String? = nil, unit: String) {
        self.title = title
        self.shortTitle = shortTitle ?? title
        self.unit = unit
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
