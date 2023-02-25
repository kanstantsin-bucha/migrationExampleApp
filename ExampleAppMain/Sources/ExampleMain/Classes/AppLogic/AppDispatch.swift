import Foundation

typealias EmptyClosure = () -> Void

func onMain(afterSeconds: Int, closure: @escaping EmptyClosure) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(afterSeconds)) {
        closure()
    }
}

func onMain(closure: @escaping EmptyClosure) {
    guard Thread.current.isMainThread else {
        DispatchQueue.main.async {
            closure()
        }
        return
    }
    closure()
}

func onSerial(closure: @escaping EmptyClosure) {
    onMain {
        closure()
    }
}
