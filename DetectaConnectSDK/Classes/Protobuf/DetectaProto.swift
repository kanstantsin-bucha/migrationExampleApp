//
//  DetectaProto.swift
//  client
//
//  Created by Kanstantsin Bucha on 22.02.21.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import Foundation

typealias ContextValues = D_Resp.Context

extension D_Resp.Status: Error {
    var isError: Bool {
        if case .ok = self {
            return false
        }
        return true
    }
}

extension D_Resp.Status: LocalizedError {
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
