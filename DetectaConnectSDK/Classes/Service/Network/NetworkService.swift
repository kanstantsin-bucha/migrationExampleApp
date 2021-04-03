//
//  NetworkService.swift
//  DetectaConnectSDK
//
//  Created by Kanstantsin Bucha on 3.04.21.
//

import Foundation



public protocol NetworkService {
    func load<T: Decodable>(url: URL, converter: ResponseConverting) -> Future<T>
}

class DefaultNetworkService: NetworkService {
    private let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    
    public func load<T: Decodable>(url: URL, converter: ResponseConverting) -> Future<T> {
        let promise = Promise<T>()
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60)
        let urlDesc = String(describing: url.absoluteString.removingPercentEncoding)
        log.operation("[URL]: \(urlDesc))")
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                log.failure("[URL]: \(urlDesc), error: \(error)")
                promise.reject(error)
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                log.failure("[URL]: \(urlDesc), error: \(NetworkServiceError.noData)")
                promise.reject(NetworkServiceError.noData)
                return
            }
            
            let result: Result<T, Error> = converter.convert(data: data, response: response)
            switch result {
            case .failure(let error):
                log.failure("[URL]: \(urlDesc), error: \(error)")
                promise.reject(error)
                
            case .success(let value)
                log.success("[URL]: \(urlDesc), value: \(value)")
                promise.resolve(value)
            }
        }
        return promise
    }
}

/*
 
 
 let result: T
 do {
     result = try JSONDecoder().decode(T.self, from: data)
 } catch {
     log.failure("[URL]: \(urlDesc), error: \(error)")
     promise.reject(error)
     return
 }
 
 let isSucceed = (200..<299).contains(response.statusCode)
 if isSucceed {
     log.success("[URL]: \(urlDesc)")
     promise.resolve(())
 } else {
     log.failure("[URL]: \(urlDesc), error: \(error)")
     promise.reject(NetworkServiceError.noData)

 }
 return*/
