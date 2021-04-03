//
//  NetworkServiceError.swift
//  DetectaConnectSDK
//
//  Created by Kanstantsin Bucha on 3.04.21.
//

import Foundation

enum NetworkServiceError: Error {
    case noData
    case invalidResultType
}

extension NetworkServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noData:
            return "No data received from the server"
            
        }
    }
}
