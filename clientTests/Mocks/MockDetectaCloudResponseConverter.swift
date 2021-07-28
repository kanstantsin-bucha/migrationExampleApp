//
//  MockDetectaCloudResponseConverter.swift
//  D-Connect
//
//  Created by Aleksandr Bucha on 28/07/2021.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import DetectaConnectSDK
import Foundation

class MockDetectaCloudResponseConverter: DetectaCloudResponseConverter {
    private(set) var convertCount = 0
    private(set) var convertParams: (data: Data?, response: HTTPURLResponse)?
    var convertResult: Result<Value, Error> = .failure(TestError())
    
    override func convert(data: Data?, response: HTTPURLResponse) -> Result<Value, Error> {
        convertCount += 1
        convertParams = (data: data, response: response)
        return convertResult
    }
}
