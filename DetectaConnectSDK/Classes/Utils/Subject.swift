//
//  Subject.swift
//  DetectaConnectSDK
//
//  Created by Konstantin on 6/5/21.
//

import Foundation

public class Subject<T> {
    public typealias SubscriptionClosure  = (T) -> Void
    private var subscriptions: [SubscriptionClosure] = []
    
    public func subscribe(closure: @escaping SubscriptionClosure) {
        subscriptions.append(closure)
    }
    
    public func send(_ value: T) {
        subscriptions.forEach { $0(value) }
    }
    
    public func cancel() {
        subscriptions.removeAll()
    }
}
