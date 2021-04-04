//
//  ValueUnitModel.swift
//  DetectaConnectSDK
//
//  Created by Kanstantsin Bucha on 4.04.21.
//

import Foundation

protocol ValueUnitModel: class {
    var title: String { get }
    var unit: String { get }
    var value: String { get }
    
    func update(value: Float)
}
