//
//  MockNetworkService.swift
//  D-Connect
//
//  Created by Aleksandr Bucha on 28/07/2021.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import DetectaConnect
import Foundation

class MockNetworkService<Value: Decodable>: NetworkService {
    
    private(set) var loadCount = 0
    private(set) var loadParams: (url: URL, converter: ResponseConverter<Value>)?
    var loadResult: Future<CloudResponseWrapper<Value>>.PromiseResult = .failure(TestError())
    
    override func load<T: Decodable>(
        url: URL,
        converter: ResponseConverter<T>
    ) -> Future<CloudResponseWrapper<T>> {
        loadCount += 1
        loadParams = (url: url, converter: converter as! ResponseConverter<Value>)
        return Promise<CloudResponseWrapper<T>>.resolved(result: loadResult as! Future<CloudResponseWrapper<T>>.PromiseResult)
    }
}
