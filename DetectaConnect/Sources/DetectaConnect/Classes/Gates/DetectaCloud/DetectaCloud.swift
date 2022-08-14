//
//  DetectaCloud.swift
//  DetectaConnect
//
//  Created by Kanstantsin Bucha on 3.04.21.
//

import Foundation

enum DetectaCloud {
    enum Endpoint {
        // Don't put a tail slash here
        static let cloudServer = "https://detecta.group/api/2"
//        Uncomment for local development
//        static let cloudServer = "http://192.168.0.193:4040"
        static let measurements = "deviceReports"
        static let environment = "environmentConfig/update"
    }
    enum Query {
        static let deviceId = "deviceId"
        static let type = "type"
        static let deviceVersion = "deviceVersion"
        static let lastHoursCount = "lastHoursCount"
    }
    enum Path {
        static let latestWithDevice = "latestWithDevice"
        static let interval = "interval"
    }
}
