//
//  EnhancedChartData.swift
//  DetectaConnectSDK
//
//  Created by Konstantin on 5/9/21.
//

import Charts
import Foundation

public struct EnhancedChartData: Equatable {
    public let xMin: TimeInterval
    public let xMax: TimeInterval
    public let xAverage: Double
    public let data: ChartData
    public let badgeEntry: ChartDataEntry?
}
