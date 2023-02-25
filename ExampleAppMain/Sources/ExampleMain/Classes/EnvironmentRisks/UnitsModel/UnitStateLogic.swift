import Foundation

public struct UnitStateLogic: Decodable {
    public var enabled: Bool
    public var range: UnitValueRange?
}

public struct UnitValueRange: Decodable {
    public var lower: Float
    public var upper: Float
    public var range: Range<Float> { lower..<upper }
}
