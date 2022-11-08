//
//  DetectaCloudResponseConverter.swift
//  DetectaConnect
//
//  Created by Kanstantsin Bucha on 3.04.21.
//

import Foundation

public enum CloudResponseWrapper<T> {
    case newData(value: T)
    case noNewData
}

open class ResponseConverter<Value: Decodable> {
    public init() {}
    
    open func convert(data: Data?, response: HTTPURLResponse) -> Result<CloudResponseWrapper<Value>, Error> {
        guard response.statusCode != 204 else {
            return .success(.noNewData)
        }
        let isSucceed = (200..<299).contains(response.statusCode)
        guard isSucceed else {
            return .failure(NetworkServiceError.failedHttpCode)
        }
        guard let data = data else {
            return .failure(NetworkServiceError.dataConversionFailed)
        }
        
        let value: Value
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            value = try decoder.decode(Value.self, from: data)
        } catch {
            return .failure(error)
        }
        return .success(.newData(value: value))
    }
}
