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
    private var sut: DetectaCloudGate!
    private var mockNetworkService: MockNetworkService<LocalContextPackage>!
    private var mockResponseConverter: MockResponseConverter<LocalContextPackage>!
        
    override func setUp() {
        sut = DetectaCloudGate()
        mockNetworkService = MockNetworkService()
        mockResponseConverter = MockResponseConverter<LocalContextPackage>()
        DetectaConnect.add(servicesList: [(mockNetworkService, NetworkService.self)])
    }
    
    override func tearDown() {
        sut = nil
        mockResponseConverter = nil
        mockNetworkService = nil
        removeAllServices()
    }
    
    func testThatProvidesValidUrlWhenFetchesLastContext() {
        // Given
        let token = "token"
      
        mockNetworkService.loadResult = .success(.newData(value: LocalContextPackage.stub()))
        
        // When
        let future = sut.fetchLastContext(token: token, converter: mockResponseConverter)

        // Then
        XCTAssertEqual(mockNetworkService.loadCount, 1)
        XCTAssertEqual(
            mockNetworkService.loadParams?.url.absoluteString.removingPercentEncoding,
            "https://detecta.group/api/2/deviceReports/latestWithDevice/token"
        )
        XCTAssertNotNil(mockNetworkService.loadParams?.converter as? MockResponseConverter<LocalContextPackage>)
        XCTAssertEqual(future.result?.isSuccess, true)
    }
}

