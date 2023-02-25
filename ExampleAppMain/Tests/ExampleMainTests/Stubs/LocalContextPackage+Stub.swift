import ExampleMain
import Foundation


extension LocalContextPackage {
    static func stub() -> LocalContextPackage {
        return LocalContextPackage(
            id: UUID().uuidString,
            deviceId: UUID().uuidString,
            createdAt: Date(),
            data: LocalContextValues.stub()
        )
    }
}
