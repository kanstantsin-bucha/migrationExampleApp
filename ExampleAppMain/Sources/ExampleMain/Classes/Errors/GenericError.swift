import Foundation

public enum GenericError: Error {
    case resourceNotFound
    case invalidData
}

extension GenericError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .resourceNotFound:
            return "The resource was not found."
            
        case .invalidData:
            return "The data is invalid"
        }
    }
}
