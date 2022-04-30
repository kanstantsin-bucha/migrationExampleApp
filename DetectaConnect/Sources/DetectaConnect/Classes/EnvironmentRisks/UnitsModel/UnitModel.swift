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
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "unit_title"
        case _shortTitle = "unit_title_short"
        case unit = "unit"
        case contextKey = "context_value_key"
        case floatPrecision = "float_precision"
    }
}
