//
//  NetworkServiceError.swift
//  DetectaConnect
//
//  Created by Kanstantsin Bucha on 3.04.21.
//

import Foundation

enum NetworkServiceError: Error {
    case noResponseData
    case failedHttpCode
    case dataConversionFailed
}

extension NetworkServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noResponseData:
            return "No http data received from the server"
        case .failedHttpCode:
            return "Request has failed http code"
        case .dataConversionFailed:
            return "The data have incorrect format"
        }
    }
}
