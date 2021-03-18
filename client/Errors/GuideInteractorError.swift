//
//  GuideInteractorError.swift
//  client
//
//  Created by Kanstantsin Bucha on 8.03.21.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import Foundation

enum GuideInteractorError: Error {
    case ssidInvalid
    case passInvalid
    case noDevice
    case timeout
}

extension GuideInteractorError: LocalizedError {
    var errorDescription: String? {
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
