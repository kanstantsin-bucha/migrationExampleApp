import ExampleMain
import Foundation

extension LocalContextValues {
    static func stub() -> LocalContextValues {
        LocalContextValues(
            millis: Int(Date().timeIntervalSince1970 * 1000),
            iaq: 50,
            coPpm: 5,
            tempCelsius: 30,
            humidity: 45,
            pressureHPa: 1008,
            co2Equivalent: 500,
            breathVocEquivalent: 1.34
        )
    }
}
