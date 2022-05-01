//
//  UnitModel.swift
//  DetectaConnect
//
//  Created by Konstantin on 5/10/21.
//

import Foundation

public struct UnitModel: Decodable, Equatable {
    public var uuid: UUID = UUID()
    public var title: String
    public var shortTitle: String { _shortTitle ?? title }
    public var _shortTitle: String?
    public var floatPrecision: Int?
    public var unit: String
    public var contextKey: String
    public var good: UnitStateLogic
    public var warning: UnitStateLogic
    public var danger: UnitStateLogic
    public var alarm: UnitStateLogic
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case _shortTitle = "title_short"
        case floatPrecision = "float_precision"
        case unit
        case contextKey = "context_value_key"
        case good
        case warning
        case danger
        case alarm
    }
}
