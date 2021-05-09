//
//  TimeSpanContextError.swift
//  DetectaConnectSDK
//
//  Created by Konstantin on 5/7/21.
//

import Foundation

enum TimeSpanContextError: Error {
    case failedDateConversion
    case noData
}

extension TimeSpanContextError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failedDateConversion:
            return "Failed to get valid fetch interval for date"
            
        case .noData:
            return "The server has no data for the interval"
        }
    }
}
