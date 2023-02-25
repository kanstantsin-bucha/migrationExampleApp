import Foundation

public struct LocalContextValues: Decodable {
    let millis: Int
    let iaq: Float
    let coPpm: Float
    let tempCelsius: Float
    let humidity: Float
    let pressureHPa: Float
    let co2Equivalent: Float
    let breathVocEquivalent: Float
    
    public init(
        millis: Int,
        iaq: Float,
        coPpm: Float,
        tempCelsius: Float,
        humidity: Float,
        pressureHPa: Float,
        co2Equivalent: Float,
        breathVocEquivalent: Float
    ) {
        self.millis = millis
        self.iaq = iaq
        self.coPpm = coPpm
        self.tempCelsius = tempCelsius
        self.humidity = humidity
        self.pressureHPa = pressureHPa
        self.co2Equivalent = co2Equivalent
        self.breathVocEquivalent = breathVocEquivalent
    }
    
    public subscript(key: String) -> Float? {
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
                return nil
            }
        }
    }
}
