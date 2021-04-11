//
//  CloudContextValues.swift
//  DetectaConnectSDK
//
//  Created by Kanstantsin Bucha on 4.04.21.
//

import Foundation

public struct CloudContextValues: Decodable {
    let iaq: Float
    let coPpm: Float
    let tempCelsius: Float
    let humidity: Float
    let pressureKPa: Float
    
    enum CodingKeys: String, CodingKey {
        case iaq
        case coPpm
        case tempCelsius
        case humidity
        case pressureKPa = "pressurePa"
    }
}
