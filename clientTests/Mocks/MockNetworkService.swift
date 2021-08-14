//
//  MockNetworkService.swift
//  D-Connect
//
//  Created by Aleksandr Bucha on 28/07/2021.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import DetectaConnect
import Foundation

class MockNetworkService<T: Decodable>: NetworkService {
    private(set) var loadCount = 0
    private(set) var loadParams: (url: URL, converter: Any)?
    var loadResult: Future<T>.PromiseResult = .failure(TestError())
    
    func load<T, RC>(
        url: URL,
        converter: RC
    ) -> Future<T> where T : Decodable, T == RC.Value, RC : ResponseConverting {
        loadCount += 1
        loadParams = (url: url, converter: converter)
        return Promise<T>.resolved(result: loadResult as! Future<T>.PromiseResult)
    }
}
