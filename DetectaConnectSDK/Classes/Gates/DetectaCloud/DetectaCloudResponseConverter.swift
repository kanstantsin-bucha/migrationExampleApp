//
//  DetectaCloudResponseConverter.swift
//  DetectaConnectSDK
//
//  Created by Kanstantsin Bucha on 3.04.21.
//

import Foundation



struct DetectaCloudResponseConverter: ResponseConverting {
    typealias Value = String
    
    func convert(data: Data?, response: HTTPURLResponse) -> Result<Value, Error> {
        let isSucceed = (200..<299).contains(response.statusCode)
        guard isSucceed else {
            return .failure(NetworkServiceError.failedHttpCode)
        }
        guard let data = data,
              let value = String(data: data, encoding: .utf8) else {
            return .failure(NetworkServiceError.dataConversionFailed)
        }
        return .success(value)
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
 
 return*/
