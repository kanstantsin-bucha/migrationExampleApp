//
//  UnitValueModel.swift
//  DetectaConnect
//
//  Created by Kanstantsin Bucha on 4.04.21.
//

import Foundation

public protocol UnitValueModel {
    var unit: UnitModel { get }
    var value: String { get }
    var state: UnitValueState { get }
    var valuePath: KeyPath<CloudContextWrapper, Float> { get }
    
    func apply(value: Float)
    func apply(contextWrapper: CloudContextWrapper)
}

extension UnitValueModel {
    public func apply(contextWrapper: CloudContextWrapper) {
        apply(value: contextWrapper[keyPath: valuePath])
    }
}
