//
//  DetectaCloudGateTests.swift
//  DetectaConnectTests
//
//  Created by Kanstantsin Bucha on 3.04.21.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import DetectaConnectSDK
import Foundation
import XCTest

class DetectaCloudGateTests: XCTestCase {
    private var gate: DetectaCloudGate!
        
    override func setUp() {
        gate = DetectaCloudGate()
    }
    override func tearDown() {
        gate = nil
        removeAllServices()
    }
}

