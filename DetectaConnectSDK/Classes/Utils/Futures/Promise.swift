//
//  Promise.swift
//  client
//
//  Created by Kanstantsin Bucha on 8.03.21.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import Foundation

public class Promise<Value>: Future<Value> {
    override public init() {}
    
    public static func rejected(error: Error) -> Promise<Value> {
        let promise = Promise<Value>()
        promise.reject(error)
        return promise
    }
    
    public static func resolved(result: Future<Value>.PromiseResult) -> Promise<Value> {
        let promise = Promise<Value>()
        switch result {
        case let .failure(error):
            promise.reject(error)
            
        case let .success(value):
            promise.resolve(value)
        }
        return promise
    }
}
