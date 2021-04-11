//
//  UrlBuilder_DetectaCloud_Test.swift
//  DetectaConnectTests
//
//  Created by Kanstantsin Bucha on 3.04.21.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import DetectaConnectSDK
import Foundation
import XCTest

class UrlBuilder_DetectaCloud_Test: XCTestCase {
    private var builder: ApiUrlBuilder!
    
    override func setUp() {
        builder = ApiUrlBuilder("https://api.com")
    }
    
    override func tearDown() {
         builder = nil
    }
    
    func testThatProvidesValidUrlWhenAddsQueryItemWithField() {
        // Arrange
        _ = builder.addPath(path: "measurements")
        
        // Act
        _ = builder.addQuery(name: "$sort", field: "millis", value: -1)
        
        // Assert
        XCTAssertEqual(
            builder.url().absoluteString.removingPercentEncoding,
            "https://api.com/measurements?$sort[millis]=-1"
        )
    }
    
    func testThatProvidesValidUrlWhenAddsQueryItemWithNoField() {
        // Arrange
        _ = builder.addPath(path: "measurements")
        
        // Act
        _ = builder.addQuery(name: "$limit", field: nil, value: 2)
        
        // Assert
        XCTAssertEqual(
            builder.url().absoluteString,
            "https://api.com/measurements?$limit=2"
        )
    }
    
    func testThatProvidesValidUrlWhenFetchsLastContext() {
        // Arrange
        // Act
        let url = builder.lastContext()
        
        // Assert
        XCTAssertEqual(
            url.absoluteString.removingPercentEncoding,
            "http://detecta.group/api/1/measurements?$limit=1&$sort[timestamp]=-1"
        )
    }
}
