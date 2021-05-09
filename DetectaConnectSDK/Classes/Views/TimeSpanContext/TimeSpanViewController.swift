//
//  TimeSpanViewController.swift
//  DetectaConnectSDK
//
//  Created by Konstantin on 4/27/21.
//

import UIKit
import Charts

class TimeSpanViewController: UIViewController {
    
    static let formatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.hour, .minute]
        f.unitsStyle = .positional
        return f
    }()
    
    var token: String!
    
    @IBOutlet weak var contextsView: UITextView!
    @IBOutlet weak var lineChartView: LineChartView!
    // Badge View
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    // Characteristics View
    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var averageValueLabel: UILabel!
    @IBOutlet weak var maxValueLabel: UILabel!
    
    private var temperatureModel: ValueUnitModel = TemperatureValueUnitModel()
    private var humidityModel: ValueUnitModel = HumidityValueUnitModel()
    private var pressureModel: ValueUnitModel = PressureValueUnitModel()
    private var co2PpmModel: ValueUnitModel = CO2ValueUnitModel()
    private var coPpmModel: ValueUnitModel = COValueUnitModel()
    private var vocPpmModel: ValueUnitModel = VocValueUnitModel()
    private var iaqModel: ValueUnitModel = IAQValueUnitModel()
    private var marker: DotMarker!
    private let axisFormatter = MyAxisValueFormatter()
    
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
            self.updateBadge(entry: nil)
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
        marker = DotMarker(color: .green.withAlphaComponent(0.3))
        lineChartView.marker = marker
        
        lineChartView.rightAxis.enabled = false
        lineChartView.drawBordersEnabled = false
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.legend.textColor = .systemBlue
        lineChartView.delegate = self
        lineChartView.scaleYEnabled = false
        
        let xAxis = lineChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 12)
        xAxis.labelTextColor = UIColor.frameworkAsset(named: "AirGray")
        xAxis.axisLineColor = .blue
        xAxis.setLabelCount(6, force: true)
        xAxis.drawGridLinesEnabled = false
        xAxis.valueFormatter = MyAxisValueFormatter()
        
        let yAxis = lineChartView.leftAxis
        yAxis.drawLabelsEnabled = false
        yAxis.drawAxisLineEnabled = false
        yAxis.drawGridLinesEnabled = false
        yAxis.drawZeroLineEnabled = false
//        yAxis.labelFont = .systemFont(ofSize: 12)
//        yAxis.labelTextColor = UIColor.frameworkAsset(named: "AirGray")
//        yAxis.axisLineColor = .blue
//        yAxis.setLabelCount(6, force: true)
    }
    
    private func update() {
        guard isUpdating else { return }
        fetch()
    }
    
    private func fetch() {
        let period = FetchPeriod.oneDay
        let valuePath: KeyPath<CloudContextWrapper, Float> = \.context.co2Equivalent
        let targetDate: Date
        do {
            targetDate = try calculateStartDate(period: period)
        } catch {
            log.error(error)
            return
        }
        service(GatesKeeper.self).cloudGate.fetchPeriodContext(
            token: token,
            startDate: targetDate,
            period: period
        )
            .onSuccess { [weak self] result in
                guard let self = self else { return }
                let values = result.data
                let data = self.chartData(withValues: values, startDate: targetDate, valuePath: valuePath)
                let average = values.average { Double($0[keyPath: valuePath]) }
                onMain {
                    self.updateCharacteristics(min: data.yMin, max: data.yMax, average: average)
                    let unixTime = targetDate.timeIntervalSince1970
                    self.lineChartView.xAxis.axisMinimum = unixTime
                    self.lineChartView.xAxis.axisMaximum = unixTime + period.rawValue
                    self.lineChartView.leftAxis.axisMinimum = data.getYMin() - abs(data.getYMin() * 0.3)
                    self.lineChartView.xAxis.setLabelCount(period.spanCount, force: true)
                    self.lineChartView.data = data
                    self.lineChartView.animate(xAxisDuration: 1)
                    var text = "Total \(values.count):\n"
                    
                    text += values.map {
                        String(
                            format: "%f.2 - %@: %@",
                            ($0.createdAt - unixTime) / 3600,
                            TimeSpanViewController.formatter.string(for: hourlyComponents($0.createdAt))!,
                            String($0[keyPath: valuePath])
                        )
                    }
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
    
    private func calculateStartDate(period: FetchPeriod) throws -> Date {
        let calendar = Calendar.current
        let start = Date().addingTimeInterval(-period.rawValue)
        var components = calendar.dateComponents([.era, .year, .month, .day, .hour], from: start)
        components.hour = 1 + (components.hour ?? 0)
        guard let date = calendar.date(from: components) else {
            throw TimeSpanContextError.failedDateConversion
        }
        return date
    }
    
    private func chartData(
        withValues values: [CloudContextWrapper],
        startDate: Date,
        valuePath: KeyPath<CloudContextWrapper, Float>
    ) -> LineChartData {
        let chartEntries = values.enumerated().map { index, value in
            return ChartDataEntry(
                x: value.createdAt,
                y: Double(value[keyPath: valuePath])
            )
        }
        let dataSet = LineChartDataSet(entries: chartEntries, label: "CO2")
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 1
        dataSet.setColor(.systemBlue)
        dataSet.fill = Fill(color: .cyan)
        dataSet.fillAlpha = 0.1
        dataSet.drawFilledEnabled = true
        dataSet.highlightEnabled = true
        dataSet.drawVerticalHighlightIndicatorEnabled = false
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.mode = .linear
        
        dataSet.valueFormatter = MyValueFormatter()
        
        return LineChartData(dataSet: dataSet)
    }
    
    private func updateBadge(entry: ChartDataEntry?) {
        guard let entry = entry else {
            unitLabel.text = "ppm"
            valueLabel.text = "~"
            timeLabel.text = ""
            return
        }
        unitLabel.text = "ppm"
        valueLabel.text = String(format: "%.0f", entry.y)
        timeLabel.text = TimeSpanViewController.formatter.string(for: hourlyComponents(entry.x))!
    }
    
    private func updateCharacteristics(min: Double, max: Double, average: Double) {
        minValueLabel.text = String(format: "%.0f", min)
        averageValueLabel.text = String(format: "%.0f", average)
        maxValueLabel.text = String(format: "%.0f", max)
    }
}

extension TimeSpanViewController: ChartViewDelegate {
    @objc func chartValueSelected(
        _ chartView: ChartViewBase,
        entry: ChartDataEntry,
        highlight: Highlight
    ) {
        onMain { [weak self] in
            self?.updateBadge(entry: entry)
        }
    }
}


public class MyAxisValueFormatter: IAxisValueFormatter {
    public func stringForValue(
        _ value: Double,
        axis: AxisBase?
    ) -> String {
        return TimeSpanViewController.formatter.string(for: hourlyComponents(value))!
    }
    
}
public class MyValueFormatter: IValueFormatter {
    public func stringForValue(
        _ value: Double,
        entry: ChartDataEntry,
        dataSetIndex: Int,
        viewPortHandler: ViewPortHandler?
    ) -> String {
        return TimeSpanViewController.formatter.string(for: hourlyComponents(value))!
    }
}

class DotMarker: MarkerImage {
    let color: UIColor
    let diameter: CGFloat = 10

    init(color: UIColor) {
        self.color = color
        super.init()
    }

    override func draw(context: CGContext, point: CGPoint) {
        var rectangle = CGRect(x: point.x, y: point.y, width: diameter, height: diameter)
        rectangle.origin.x -= diameter / 2
        rectangle.origin.y -= diameter / 2

        // circle
        let clipPath = UIBezierPath(roundedRect: rectangle, cornerRadius: diameter / 2).cgPath
        context.addPath(clipPath)
        context.setFillColor(self.color.cgColor)
        context.setStrokeColor(UIColor.darkGray.cgColor)
        context.closePath()
        context.drawPath(using: .fillStroke)
    }

    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
    }
}


class PillMarker: MarkerImage {
    
    public var min: TimeInterval?

    private (set) var color: UIColor
    private (set) var font: UIFont
    private (set) var textColor: UIColor
    private var labelText: String = ""
    private var attrs: [NSAttributedString.Key: AnyObject]!

    static let formatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.minute, .second]
        f.unitsStyle = .short
        return f
    }()

    init(color: UIColor, font: UIFont, textColor: UIColor) {
        self.color = color
        self.font = font
        self.textColor = textColor

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attrs = [.font: font, .paragraphStyle: paragraphStyle, .foregroundColor: textColor, .baselineOffset: NSNumber(value: -4)]
        super.init()
    }

    override func draw(context: CGContext, point: CGPoint) {
        // custom padding around text
        let labelWidth = labelText.size(withAttributes: attrs).width + 10
        // if you modify labelHeigh you will have to tweak baselineOffset in attrs
        let labelHeight = labelText.size(withAttributes: attrs).height + 4

        // place pill above the marker, centered along x
        var rectangle = CGRect(x: point.x, y: point.y, width: labelWidth, height: labelHeight)
        rectangle.origin.x -= rectangle.width / 2.0
        let spacing: CGFloat = 20
        rectangle.origin.y -= rectangle.height + spacing

        // rounded rect
        let clipPath = UIBezierPath(roundedRect: rectangle, cornerRadius: 6.0).cgPath
        context.addPath(clipPath)
        context.setFillColor(UIColor.white.cgColor)
        context.setStrokeColor(UIColor.black.cgColor)
        context.closePath()
        context.drawPath(using: .fillStroke)

        // add the text
        labelText.draw(with: rectangle, options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
    }

    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        labelText = customString(entry.x)
    }

    private func customString(_ value: Double) -> String {
        let baseline = min ?? 0
        let formattedString = PillMarker.formatter.string(
            from: TimeInterval(value) - baseline
        )!
        // using this to convert the left axis values formatting, ie 2 min
        return "\(formattedString)"
    }
}

fileprivate func hourlyComponents(_ timeInterval: TimeInterval) -> DateComponents {
    let calendar = Calendar.current
    return calendar.dateComponents([.hour, .minute], from: Date(timeIntervalSince1970: timeInterval))
}

