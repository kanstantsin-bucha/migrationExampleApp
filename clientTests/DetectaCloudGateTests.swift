//
//  DetectaCloudGateTests.swift
//  DetectaConnectTests
//
//  Created by Kanstantsin Bucha on 3.04.21.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import DetectaConnect
import Foundation
import XCTest

class DetectaCloudGateTests: XCTestCase {
    private var gate: DetectaCloudGate!
    private var mockDetectaCloudResponseConverter: MockDetectaCloudResponseConverter!
    private var mockNetworkService: MockNetworkService<CloudContext>!
        
    override func setUp() {
        mockDetectaCloudResponseConverter = MockDetectaCloudResponseConverter()
        gate = DetectaCloudGate(converter: mockDetectaCloudResponseConverter)
        
        mockNetworkService = MockNetworkService<CloudContext>()
        addService(NetworkService.self, impl: mockNetworkService)
    }
    
    override func tearDown() {
        gate = nil
        removeAllServices()
    }
    
    func testThatProvidesValidUrlWhenFetchesLastContext() {
        // Arrange
        let token = "token"
        let mockContext = CloudContext(total: 2, limit: 3, skip: 1, data: [])
        mockNetworkService.loadResult = .success(mockContext)
        
        // Act
        let future = gate.fetchLastContext(token: token)

        // Assert
        XCTAssertEqual(mockNetworkService.loadCount, 1)
        XCTAssertEqual(
            mockNetworkService.loadParams?.url.absoluteString.removingPercentEncoding,
            "http://detecta.group/api/1/measurements?uid=token&$limit=1&$sort[createdAt]=-1"
        )
        XCTAssertNotNil(mockNetworkService.loadParams?.converter as? MockDetectaCloudResponseConverter)
        XCTAssertEqual(future.result?.isSuccess, true)
    }
}

