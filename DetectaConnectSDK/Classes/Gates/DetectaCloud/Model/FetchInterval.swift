//
//  FetchInterval.swift
//  BlueSwift
//
//  Created by Konstantin on 5/9/21.
//

import Foundation

public enum FetchInterval: TimeInterval {
    case oneHour = 3600
    case eightHours = 28800
    case oneDay = 86400
    
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
