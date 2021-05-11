//
//  UnitModel.swift
//  DetectaConnectSDK
//
//  Created by Konstantin on 5/10/21.
//

import Foundation

public struct UnitModel: Equatable {
    public var uuid: UUID = UUID()
    public var title: String
    public var unit: String
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
