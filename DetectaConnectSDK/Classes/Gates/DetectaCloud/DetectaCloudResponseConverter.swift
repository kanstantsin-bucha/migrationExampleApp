//
//  DetectaCloudResponseConverter.swift
//  DetectaConnectSDK
//
//  Created by Kanstantsin Bucha on 3.04.21.
//

import Foundation



struct DetectaCloudResponseConverter: ResponseConverting {
    typealias Value = CloudContext
    
    func convert(data: Data?, response: HTTPURLResponse) -> Result<Value, Error> {
        let isSucceed = (200..<299).contains(response.statusCode)
        guard isSucceed else {
            return .failure(NetworkServiceError.failedHttpCode)
        }
        guard let data = data else {
            return .failure(NetworkServiceError.dataConversionFailed)
        }
        
        let value: CloudContext
        do {
            value = try JSONDecoder().decode(CloudContext.self, from: data)
        } catch {
            return .failure(error)
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
