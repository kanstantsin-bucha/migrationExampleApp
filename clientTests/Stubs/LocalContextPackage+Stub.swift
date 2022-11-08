//
//  LocalContextPackage+Stub.swift
//  DetectaConnectTests
//
//  Created by Kanstantsin Bucha on 08/11/2022.
//  Copyright © 2022 Detecta Group. All rights reserved.
//

import DetectaConnect
import Foundation


extension LocalContextPackage {
    static func stub() -> LocalContextPackage {
        return LocalContextPackage(
            id: UUID().uuidString,
            deviceId: UUID().uuidString,
            createdAt: Date(),
            data: LocalContextValues.stub()
        )
    }
}
