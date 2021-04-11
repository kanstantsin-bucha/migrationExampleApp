//
//  ResponseConverting.swift
//  DetectaConnectSDK
//
//  Created by Kanstantsin Bucha on 3.04.21.
//

import Foundation

public protocol ResponseConverting {
    associatedtype Value
    func convert(data: Data?, response: HTTPURLResponse) -> Result<Value, Error>
}
