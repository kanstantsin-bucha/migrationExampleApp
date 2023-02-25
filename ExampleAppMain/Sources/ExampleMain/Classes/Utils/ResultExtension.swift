import Foundation

extension Result {
    public var isSuccess: Bool {
        guard case .success = self else {
            return false
        }
        return true
    }
}
