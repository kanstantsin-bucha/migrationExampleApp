import Foundation

public enum GuideInteractorError: Error {
    case ssidInvalid
    case passInvalid
    case noDevice
    case timeout
}

extension GuideInteractorError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .passInvalid:
            return "The password length should be from 1 to 16 chars"
            
        case .ssidInvalid:
            return "The network name length should be from 1 to 16 chars"
        
        case .noDevice:
            return "There is no connected device to setup"
        
        case .timeout:
            return "Command timeout have been reached"
        }
    }
}
