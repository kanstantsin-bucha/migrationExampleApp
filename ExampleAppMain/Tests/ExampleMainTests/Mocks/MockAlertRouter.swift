import Foundation
import ExampleMain

class MockAlertRouter: AlertRouter, Service {
    let error = "SomeError"
    var showErrorCounter = 0
    func show(error: Error) {
        showErrorCounter += 1
        print(error)
    }
}
