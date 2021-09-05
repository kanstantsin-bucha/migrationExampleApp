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
}