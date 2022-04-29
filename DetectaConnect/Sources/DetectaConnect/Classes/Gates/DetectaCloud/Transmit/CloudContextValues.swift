//
//  CloudContextValues.swift
//  DetectaConnect
//
//  Created by Kanstantsin Bucha on 4.04.21.
//

import Foundation

public struct CloudContextValues: Decodable {
    let iaq: Float
    let coPpm: Float
    let tempCelsius: Float
    let humidity: Float
    let pressureHPa: Float
    let co2Equivalent: Float
    let breathVocEquivalent: Float
    
    public subscript(key: String) -> Float {
        get
        {
            switch key {
            case "iaq": return iaq
            case "coPpm": return coPpm
            case "tempCelsius": return tempCelsius
            case "humidity": return humidity
            case "pressureHPa": return pressureHPa
            case "co2Equivalent": return co2Equivalent
            case "breathVocEquivalent": return breathVocEquivalent
            default:
                log.error("invalid subscript key: \(key), returning 0")
                return 0
            }
        }
    }
}
