//
//  TimeSpanContextError.swift
//  DetectaConnectSDK
//
//  Created by Konstantin on 5/7/21.
//

import Foundation

enum TimeSpanContextError: Error {
    case failedDateConversion
}

extension TimeSpanContextError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failedDateConversion:
            return "Failed to get valid fetch interval for date"
        }
    }
}
