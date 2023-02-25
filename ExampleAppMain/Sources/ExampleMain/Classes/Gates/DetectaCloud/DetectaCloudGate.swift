import Foundation

public enum CloudResponseWrapper<T> {
    case newData(value: T)
    case noNewData
}

public class DetectaCloudGate {
    // on the D-Cloud there is the deflator logic that sends only representative results of count 50
    // this limit is the limit of fetch results of the search query on the server
    private let fetchLimit = 2000
    
    public init() {}
    
    public func fetchLastContext(
        token: String
    ) -> Future<CloudResponseWrapper<LocalContextPackage>> {
        Promise<CloudResponseWrapper<LocalContextPackage>>
            .resolved(result: .success(.newData(value: anyContexts()[0])))
    }
    
    public func fetchEnvironmentConfig(
        currentVersion: String
    ) -> Future<CloudResponseWrapper<EnvironmentConfig>> {
        return Promise<CloudResponseWrapper<EnvironmentConfig>>
            .resolved(result: .success(.noNewData))
    }
    
    public func fetchIntervalContext(
        token: String,
        interval: FetchInterval
    ) -> Future<CloudResponseWrapper<[LocalContextPackage]>> {
        Promise<CloudResponseWrapper<[LocalContextPackage]>>
            .resolved(result: .success(.newData(
                value: anyContexts()
            )))
    }
    
    private func anyContexts() -> [LocalContextPackage] {
        [
            LocalContextPackage(
                id: "21332421",
                deviceId: "",
                createdAt: Date(timeIntervalSinceNow: -6 * 600),
                data: anyData()[0]
            ),
            LocalContextPackage(
                id: "21332422",
                deviceId: "",
                createdAt: Date(timeIntervalSinceNow: -4 * 600),
                data: anyData()[1]
            ),
            LocalContextPackage(
                id: "21332423",
                deviceId: "",
                createdAt: Date(timeIntervalSinceNow: -2 * 600),
                data: anyData()[2]
            ),
            LocalContextPackage(
                id: "21332424",
                deviceId: "",
                createdAt: Date(timeIntervalSinceNow: -0.5 * 600),
                data: anyData()[3]
            ),
        ]
    }
    
    private func anyData() -> [LocalContextValues] {
        [
            LocalContextValues(
                millis: 112233233,
                iaq: 100,
                coPpm: 1,
                tempCelsius: 32.7,
                humidity: 46,
                pressureHPa: 1008,
                co2Equivalent: 834,
                breathVocEquivalent: 2
            ),
            LocalContextValues(
                millis: 112243433,
                iaq: 100,
                coPpm: 1,
                tempCelsius: 32.6,
                humidity: 46,
                pressureHPa: 1008,
                co2Equivalent: 854,
                breathVocEquivalent: 2
            ),
            LocalContextValues(
                millis: 112253633,
                iaq: 110,
                coPpm: 1,
                tempCelsius: 32.5,
                humidity: 47,
                pressureHPa: 1006,
                co2Equivalent: 876,
                breathVocEquivalent: 2
            ),
            LocalContextValues(
                millis: 112263833,
                iaq: 120,
                coPpm: 1,
                tempCelsius: 32.4,
                humidity: 47,
                pressureHPa: 1007,
                co2Equivalent: 932,
                breathVocEquivalent: 2
            ),
        ]
    }
}

extension DetectaCloudGate: GateKeeper {
    var isOpen: Bool { true }
    
    func summon() {
        // not used
    }
    
    func open() {
        // not applicable
    }
    
    func close() {
        // not applicable
    }
}
