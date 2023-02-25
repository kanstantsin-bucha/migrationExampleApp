import Foundation

typealias Observe<T> = (T) -> Void

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
