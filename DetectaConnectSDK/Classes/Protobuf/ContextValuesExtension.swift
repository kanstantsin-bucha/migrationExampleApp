//
//  ContextValuesExtension.swift
//  client
//
//  Created by bucha on 11/22/20.
//  Copyright © 2020 Detecta Group. All rights reserved.
//

import Foundation

extension ContextValues: CustomDebugStringConvertible {
    public var debugDescription: String {
        
        return """
            <ContextValues millis: \(millis), busVoltage \(busVoltage),
            coZeroV \(coZeroV), coV \(coV), coPpm \(coPpm),
            tempCelsius \(tempCelsius), pressurePa \(pressurePa), humidity \(humidity),
            gasResistance \(gasResistance), iaq \(iaq), staticIaq \(staticIaq),
            co2Equivalent \(co2Equivalent), breathVocEquivalent \(breathVocEquivalent),
            compGasValue \(compGasValue), gasPercentage \(gasPercentage),
            co2Equivalent \(co2Equivalent), breathVocEquivalent \(breathVocEquivalent) >
            """
    }
}
