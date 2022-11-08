//
//  MockAlertRouter.swift
//  DetectaConnectTests
//
//  Created by Aleksandr Bucha on 25/10/2021.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import Foundation
import DetectaConnect

class MockAlertRouter: AlertRouter, Service {
    let error = "SomeError"
    var showErrorCounter = 0
    func show(error: Error) {
        showErrorCounter += 1
        print(error)
    }
}
