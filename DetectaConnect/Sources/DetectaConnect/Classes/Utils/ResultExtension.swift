//
//  ResultExtension.swift
//  DetectaConnect
//
//  Created by Aleksandr Bucha on 28/07/2021.
//

import Foundation

extension Result {
    public var isSuccess: Bool {
        guard case .success = self else {
            return false
        }
        return true
    }
}
