//
//  UnitStateLogic.swift
//  
//
//  Created by Kanstantsin Bucha on 30/04/2022.
//

import Foundation

public struct UnitStateLogic: Decodable {
    public var enabled: Bool
    public var ranges: [UnitValueRange]?
}

public struct UnitValueRange: Decodable {
    public var lower: Float
    public var upper: Float
    public var range: Range<Float> { lower..<upper }
}
