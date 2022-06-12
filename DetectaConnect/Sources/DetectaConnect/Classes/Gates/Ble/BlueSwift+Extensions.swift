//
//  Characteristic.swift
//  client
//
//  Created by Kanstantsin Bucha on 8.03.21.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import Foundation
import BlueSwift

extension Characteristic {
    convenience init(_ uuid: String, isObserving: Bool = false) {
        do {
            try self.init(uuid: uuid, shouldObserveNotification: isObserving)
        } catch {
            preconditionFailure("The characteristic uuid string is not valid: \(error)")
        }
    }
}

extension BlueSwift.Service {
    convenience init(_ uuid: String, characteristics: [Characteristic]) {
        do {
            try self.init(uuid: uuid, characteristics: characteristics)
        } catch {
            preconditionFailure("The service uuid string is not valid: \(error)")
        }
    }
}

extension Configuration {
    init(_ advertisement: String, services: [BlueSwift.Service]) {
        do {
            try self.init(services: services, advertisement: advertisement)
        } catch {
            preconditionFailure("The advertisement uuid string is not valid: \(error)")
        }
    }
}
