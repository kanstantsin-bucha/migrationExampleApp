//
//  DetectaProto.swift
//  client
//
//  Created by Kanstantsin Bucha on 22.02.21.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import Foundation

typealias ContextValues = Detecta_Response.GetContextValues

extension Detecta_Response.ProcessingStatus: Error {
    var isError: Bool {
        if case .ok = self {
            return false
        }
        return true
    }
}

extension Detecta_Response.ProcessingStatus: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .ok:
            return "No error"
            
        case .generalError:
            return "General Device Error"
            
        case .serviceError:
            return "Device Service Error"
            
        case .unsupported:
            return "Device has no capabilities to proceed with request"
            
        default:
            return "Transmit protocol error"
        }
    }
}
