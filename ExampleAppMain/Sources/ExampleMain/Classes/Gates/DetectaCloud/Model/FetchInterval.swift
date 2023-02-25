import Foundation

public enum FetchInterval: UInt {
    case oneHour = 1
    case eightHours = 8
    case oneDay = 24
    
    var title: String {
        switch self {
        case .oneHour:
            return "1h"
        
        case .eightHours:
            return "8h"
            
        case .oneDay:
            return "1d"
        }
    }
}
