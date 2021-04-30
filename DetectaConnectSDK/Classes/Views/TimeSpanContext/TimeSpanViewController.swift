//
//  TimeSpanViewController.swift
//  DetectaConnectSDK
//
//  Created by Konstantin on 4/27/21.
//

import UIKit
import Charts

class TimeSpanViewController: UIViewController {
    var token: String!
    
    @IBOutlet weak var contextsView: UITextView!
    @IBOutlet weak var lineChartView: LineChartView!
    
    private var temperatureModel: ValueUnitModel = TemperatureValueUnitModel()
    private var humidityModel: ValueUnitModel = HumidityValueUnitModel()
    private var pressureModel: ValueUnitModel = PressureValueUnitModel()
    private var co2PpmModel: ValueUnitModel = CO2ValueUnitModel()
    private var coPpmModel: ValueUnitModel = COValueUnitModel()
    private var vocPpmModel: ValueUnitModel = VocValueUnitModel()
    private var iaqModel: ValueUnitModel = IAQValueUnitModel()
    
    private var isUpdating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onMain {
            self.isUpdating = true
            self.update()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        onMain {
            self.isUpdating = false
        }
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Private method
    
    private func configure() {
        lineChartView.rightAxis.enabled = true
        lineChartView.drawBordersEnabled = false
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.gridBackgroundColor = .white
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.legend.textColor = .systemBlue
        
        let xAxis = lineChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 12)
        xAxis.labelTextColor = UIColor.frameworkAsset(named: "AirGray")
        xAxis.axisLineColor = .blue
        xAxis.setLabelCount(6, force: true)
        xAxis.drawGridLinesEnabled = false
        
        let yAxis = lineChartView.leftAxis
        yAxis.labelFont = .systemFont(ofSize: 12)
        yAxis.labelTextColor = UIColor.frameworkAsset(named: "AirGray")
        yAxis.axisLineColor = .blue
        yAxis.setLabelCount(6, force: true)
    }
    
    private func update() {
        guard isUpdating else { return }
        fetch()
    }
    
    private func fetch() {
        let period = FetchPeriod.eightHours
        let valuePath: KeyPath<CloudContextWrapper, Float> = \.context.co2Equivalent
        let periodStart = Date().timeIntervalSince1970 - period.rawValue
        service(GatesKeeper.self).cloudGate.fetchPeriodContext(
            token: token,
            endDate: Date(),
            period: period
        )
            .onSuccess { [weak self] result in
                guard let self = self else { return }
                let values = result.data
                let chartEntries = values.enumerated().map { index, value in
                    return ChartDataEntry(
                        x: (value.createdAt - periodStart) * period.normalizationCoefficient,
                        y: Double(value[keyPath: valuePath])
                    )
                }
                let dataSet = LineChartDataSet(entries: chartEntries, label: "CO2")
                dataSet.drawCirclesEnabled = false
                dataSet.lineWidth = 3
                dataSet.setColor(.systemBlue)
                dataSet.fill = Fill(color: .cyan)
                dataSet.fillAlpha = 0.1
                dataSet.drawFilledEnabled = true
                dataSet.highlightLineWidth = 2
                dataSet.highlightColor = .green.withAlphaComponent(0.7)
                dataSet.drawValuesEnabled = false
                
                let data = LineChartData(dataSet: dataSet)
                onMain {
                    self.lineChartView.xAxis.setLabelCount(period.spanCount, force: true)
                    self.lineChartView.data = data
                    self.lineChartView.animate(xAxisDuration: 1)
                    var text = "Total \(values.count):\n"
                    text += values.map { "\($0.created): \(String($0[keyPath: valuePath]))" }
                        .joined(separator: ",\n")
                    log.event("Loaded \(values.count) values")
                    self.contextsView.text = text
                }
            }
            .onFailure { error in
                onMain {
                    service(AlertRouter.self).show(error: error)
                }
            }
    }
}

