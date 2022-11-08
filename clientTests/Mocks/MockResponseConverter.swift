//
//  MockResponseConverter.swift
//  DetectaConnectTests
//
//  Created by Kanstantsin Bucha on 08/11/2022.
//  Copyright © 2022 Detecta Group. All rights reserved.
//

import DetectaConnect
import Foundation

class MockResponseConverter<Value: Decodable>: ResponseConverter<Value> {
    
    private(set) var convertCount = 0
    private(set) var convertParams: (data: Data?, response: HTTPURLResponse)?
    var convertResult: Result<CloudResponseWrapper<Value>, Error> = .failure(TestError())
    override func convert(data: Data?, response: HTTPURLResponse) -> Result<CloudResponseWrapper<Value>, Error> {
        convertParams = (data, response)
        convertCount += 1
        return convertResult
    }
}
