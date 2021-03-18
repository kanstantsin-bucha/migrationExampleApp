//
//  Promise.swift
//  client
//
//  Created by Kanstantsin Bucha on 8.03.21.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import Foundation

class Promise<Value>: Future<Value> {
    static func rejected(error: Error) -> Promise<Value> {
        let promise = Promise<Value>()
        promise.reject(error)
        return promise
    }
}
