//
//  FetchPeriod.swift
//  BlueSwift
//
//  Created by Konstantin on 5/9/21.
//

import Foundation

public enum FetchPeriod: TimeInterval {
    case oneHour = 3600
    case eightHours = 28800
    case oneDay = 86400
    
    var spanCount: Int {
        switch self {
        case .oneHour:
            return 4
        
        case .eightHours:
            return 4
            
        case .oneDay:
            return 4
        }
    }
}
