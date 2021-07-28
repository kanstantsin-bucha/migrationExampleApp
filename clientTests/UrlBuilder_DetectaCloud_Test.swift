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
        _ = builder.addItem(name: "$sort", value: -1)
        
        // Assert
        XCTAssertEqual(
            builder.url().absoluteString.removingPercentEncoding,
            "https://api.com/measurements?$sort=-1"
        )
    }
    
    func testThatProvidesValidUrlWhenAddsQueryItemWithNoField() {
        // Arrange
        _ = builder.addPath(path: "measurements")
        
        // Act
        _ = builder.addItem(name: "$limit", value: 2)
        
        // Assert
        XCTAssertEqual(
            builder.url().absoluteString,
            "https://api.com/measurements?$limit=2"
        )
    }
}
