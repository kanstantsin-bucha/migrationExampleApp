//
//  NetworkService.swift
//  DetectaConnect
//
//  Created by Kanstantsin Bucha on 3.04.21.
//

import Foundation

open class NetworkService: Service {
    private let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    
    public init() {}
    
    open func load<T: Decodable>(url: URL, converter: ResponseConverter<T>) -> Future<CloudResponseWrapper<T>> {
        let promise = Promise<CloudResponseWrapper<T>>()
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60)
        let urlDesc = String(describing: url.absoluteString.removingPercentEncoding)
        log.operation("[URL]: \(urlDesc))")
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                log.failure("[URL]: \(urlDesc), error: \(error)")
                promise.reject(error)
                return
            }
            guard let response = response as? HTTPURLResponse else {
                log.failure("[URL]: \(urlDesc), error: \(NetworkServiceError.noResponseData)")
                promise.reject(NetworkServiceError.noResponseData)
                return
            }
            
            let result = converter.convert(data: data, response: response)
            switch result {
            case .failure(let error):
                log.failure("[URL]: \(urlDesc), error: \(error)")
                promise.reject(error)
                
            case .success(let value):
                log.success("[URL]: \(urlDesc), value: \(value)")
                promise.resolve(value)
            }
        }.resume()
        return promise
    }
}
