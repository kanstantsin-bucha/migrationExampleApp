//
//  Future.swift
//  client
//
//  Created by Kanstantsin Bucha on 8.03.21.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

// https://www.swiftbysundell.com/articles/under-the-hood-of-futures-and-promises-in-swift/

import Foundation

class Future<Value> {
    typealias Result = Swift.Result<Value, Error>
    
    fileprivate var result: Result? {
        willSet {
            guard result == nil else {
                preconditionFailure("Promise can be resolved only once")
            }
        }
        // Observe whenever a result is assigned, and report it:
        didSet { result.map(report) }
    }
    private var callbacks = [(Result) -> Void]()
    
    @discardableResult
    func onSuccess(_ closure: @escaping (Value) -> Void) -> Future<Value> {
        observe { result in
            if case .success(let value) = result {
                closure(value)
            }
        }
        return self
    }
    
    @discardableResult
    func onFailure(_ closure: @escaping (Error) -> Void) -> Future<Value> {
        observe { result in
            if case .failure(let error) = result {
                closure(error)
            }
        }
        return self
    }
    
    @discardableResult
    func finally(_ closure: @escaping () -> Void) -> Future<Value> {
        observe { _ in
            closure()
        }
        return self
    }
    
    private func observe(using callback: @escaping (Result) -> Void) {
        // If a result has already been set, call the callback directly:
        if let result = result {
            return callback(result)
        }
        
        callbacks.append(callback)
    }
    
    private func report(result: Result) {
        callbacks.forEach { $0(result) }
        callbacks = []
    }
}

extension Promise {
    func resolve(_ value: Value) {
        result = .success(value)
    }
    
    func reject(_ error: Error) {
        result = .failure(error)
    }
}
