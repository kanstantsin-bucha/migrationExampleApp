//
//  TimeSpanViewModel.swift
//  DetectaConnectSDK
//
//  Created by Konstantin on 5/9/21.
//

import Combine
import Foundation

public enum TimeSpanViewState: Equatable {
    case undefined
    case loading
    case updated(data: EnhancedChartData)
    case failed
}

open class TimeSpanViewModel {
    public var stateSubject = PassthroughSubject<TimeSpanViewState, Never>()
    public var intervalTitle: String { interval.title }
    private var state: TimeSpanViewState {
        didSet {
            stateSubject.send(state)
        }
    }
    private var interval: FetchInterval = .oneDay
    private let token: String
    
    public init(token: String) {
        self.token = token
        self.state = .undefined
    }
    
    public func toggleInterval() {
        onMain {
            switch self.interval {
            case .oneHour:
                self.interval = .eightHours
            
            case .eightHours:
                self.interval = .oneDay
                
            case .oneDay:
                self.interval = .oneHour
            }
            self.fetch(interval: self.interval)
        }
    }
    
    public func viewWillAppear() {
        onMain {
            self.fetch(interval: self.interval)
        }
    }
    
    // MARK: - Private methods
    
    private func fetch(interval: FetchInterval) {
        log.operation("fetch \(interval)")
        guard state != .loading else {
            log.success("fetch skipped")
            return
        }
        let valuePath: KeyPath<CloudContextWrapper, Float> = \.context.co2Equivalent
        let startDate: Date
        do {
            startDate = try calculateStartDate(interval: interval)
        } catch {
            log.failure("fetch error: \(error)")
            return
        }
        self.state = .loading
        service(GatesKeeper.self).cloudGate.fetchIntervalContext(
            token: token,
            startDate: startDate,
            interval: interval
        )
        .onSuccess { [weak self] result in
            guard let self = self else { return }
            let values = result.data
            guard !values.isEmpty else {
                self.state = .failed
                onMain {
                    service(AlertRouter.self).show(error: TimeSpanContextError.noData)
                }
                return
            }
            let data = service(ChartInteractor.self).chartData(
                withValues: values,
                valuePath: valuePath
            )
            let start = startDate.timeIntervalSince1970
            let average = values.average { Double($0[keyPath: valuePath]) }
            self.state = .updated(
                data: EnhancedChartData(
                    xMin: start,
                    xMax: start + interval.rawValue,
                    xAverage: average,
                    xSpanCount: interval.spanCount,
                    data: data,
                    badgeEntry: nil
                )
            )
        }
        .onFailure { [weak self] error in
            self?.state = .failed
            onMain {
                service(AlertRouter.self).show(error: error)
            }
        }
    }


    private func calculateStartDate(interval: FetchInterval) throws -> Date {
        let calendar = Calendar.current
        let start = Date().addingTimeInterval(-interval.rawValue)
        var components = calendar.dateComponents([.era, .year, .month, .day, .hour], from: start)
        components.hour = 1 + (components.hour ?? 0)
        guard let date = calendar.date(from: components) else {
            throw TimeSpanContextError.failedDateConversion
        }
        return date
    }
}
