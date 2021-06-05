//
//  TimeSpanViewModel.swift
//  DetectaConnectSDK
//
//  Created by Konstantin on 5/9/21.
//

import Combine
import Charts
import Foundation

public struct UnitsState: Equatable {
    public var units: [UnitModel]
    public var selectedIndex: Int?
    
    public var selectedUnit: UnitModel? {
        guard let selected = selectedIndex, selected < units.count else { return nil }
        return units[selected]
    }
}

public enum TimeSpanViewState: Equatable {
    case undefined
    case loading(intervalTitle: String)
    case updated(data: EnhancedChartData,
                 unitsState: UnitsState,
                 intervalTitle: String,
                 isNoData: Bool)
    case failed
}

open class TimeSpanViewModel {
    public var stateSubject = Subject<TimeSpanViewState>()
    private var state: TimeSpanViewState {
        didSet {
            stateSubject.send(state)
        }
    }
    
    private var units: [UnitValueModel] = [
        IAQValueUnitModel(),
        TemperatureValueUnitModel(),
        HumidityValueUnitModel(),
        CO2ValueUnitModel(),
        COValueUnitModel(),
        VocValueUnitModel(),
        PressureValueUnitModel()
    ]
    
    private var fetchedContext: (start: TimeInterval, context: CloudContext)?
    private lazy var unit: UnitValueModel = units.first!
    private var interval: FetchInterval = .oneHour
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
            self.performFetch()
        }
    }
    
    public func select(unit: UnitModel) {
        onMain { self.performUnitSelection(incoming: unit) }
    }
    
    public func viewWillAppear() {
        onMain { self.performFetch() }
    }
    
    public func badge(x: Double?, y: Double?) -> (value: String, color: UIColor, unit: String, time: String) {
        guard let time = x, let value = y else {
            return (
                value: "~",
                color: .systemGreen,
                unit: unit.unit.unit,
                time: ""
            )
        }
        unit.apply(value: Float(value))
        return (
            value: unit.value,
            color: .with(state: unit.state),
            unit: unit.unit.unit,
            time: service(ChartInteractor.self).hourlyString(timeInterval: time)
        )
    }
    
    // MARK: - Private methods
    
    private func performFetch() {
        fetch(
            interval: interval,
            unitValue: unit,
            units: units.map { $0.unit }
        )
    }
    
    private func performUnitSelection(incoming: UnitModel) {
        guard let targetUnit = units.first(where: { $0.unit.uuid == incoming.uuid }),
              unit.unit != incoming else {
            return
        }
        unit = targetUnit
        guard let (start, context) = fetchedContext else {
            performFetch()
            return
        }
        update(
            start: start,
            values: context.data,
            unitValue: unit,
            units: units.map { $0.unit }
        )
    }
    
    private func fetch(interval: FetchInterval, unitValue: UnitValueModel, units: [UnitModel]) {
        log.operation("fetch \(interval)")
        /* guard */ if case .loading = state {
            log.success("fetch skipped")
            return
        }
        let startDate: Date
        do {
            startDate = try calculateStartDate(interval: interval)
        } catch {
            log.failure("fetch error: \(error)")
            return
        }
        self.state = .loading(intervalTitle: interval.title)
        service(GatesKeeper.self).cloudGate.fetchIntervalContext(
            token: token,
            startDate: startDate,
            interval: interval
        )
        .onSuccess { [weak self] context in
            let start = startDate.timeIntervalSince1970
            self?.fetchedContext = (start: start, context: context)
            self?.update(
                start: start,
                values: context.data,
                unitValue: unitValue,
                units: units
            )
        }
        .onFailure { [weak self] error in
            self?.state = .failed
            onMain {
                service(AlertRouter.self).show(error: error)
            }
        }
    }
    
    private func update(
        start: TimeInterval,
        values: [CloudContextWrapper],
        unitValue: UnitValueModel,
        units: [UnitModel]
    ) {
        guard !values.isEmpty else {
            self.state = .updated(
                data: EnhancedChartData(
                    xMin: 0,
                    xMax: 0,
                    xAverage: 0,
                    data: nil,
                    badgeEntry: nil
                ),
                unitsState: UnitsState(
                    units: units,
                    selectedIndex: units.firstIndex(where: { $0 == unitValue.unit })
                ),
                intervalTitle: interval.title,
                isNoData: true
            )
            return
        }
        let (data, preselectedEntry) = service(ChartInteractor.self).chartData(
            withValues: values,
            valuePath: unitValue.valuePath
        )
        let average = values.average { Double($0[keyPath: unitValue.valuePath]) }
        self.state = .updated(
            data: EnhancedChartData(
                xMin: start,
                xMax: start + interval.rawValue,
                xAverage: average,
                data: data,
                badgeEntry: preselectedEntry
            ),
            unitsState: UnitsState(
                units: units,
                selectedIndex: units.firstIndex(where: { $0 == unitValue.unit })
            ),
            intervalTitle: interval.title,
            isNoData: false
        )
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
