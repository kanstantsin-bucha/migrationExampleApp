//
//  ChartInteractor.swift
//  DetectaConnect
//
//  Created by Konstantin on 5/9/21.
//

import Charts
import UIKit

open class ChartInteractor: Service {
    let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    public init() {}
    
    public func hourlyString(timeInterval: TimeInterval) -> String {
        let result = formatter.string(for: hourlyComponents(timeInterval)) ?? ""
        return result
    }
    
    public func chartData(
        withValues values: [CloudContextWrapper],
        extractor: ContextValueExtractor
    ) -> (data: LineChartData, preselectedEntry: ChartDataEntry?) {
        let chartEntries = values.enumerated().map { index, value in
            return ChartDataEntry(
                x: value.createdAt.timeIntervalSince1970,
                y: Double(extractor(value.data))
            )
        }
        let dataSet = LineChartDataSet(entries: chartEntries, label: "")
        dataSet.applyAppearance()
        return (
            data: LineChartData(dataSet: dataSet),
            preselectedEntry: dataSet.first(where: { $0.y == dataSet.yMax })
        )
    }
    
    // MARK: - Private methods
    
    private func hourlyComponents(_ timeInterval: TimeInterval) -> DateComponents {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: Date(timeIntervalSince1970: timeInterval))
        return components
    }
}

public class HourlyAxisValueFormatter: IndexAxisValueFormatter {
    public override func stringForValue(
        _ value: Double,
        axis: AxisBase?
    ) -> String {
        return service(ChartInteractor.self).hourlyString(timeInterval: value)
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

    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {}
}


extension LineChartView {
    func applyAppearance() {
        marker = DotMarker(color: .green.withAlphaComponent(0.3))
        legend.enabled = false
        
        rightAxis.enabled = false
        drawBordersEnabled = false
        drawGridBackgroundEnabled = false
        rightAxis.drawGridLinesEnabled = false
        scaleYEnabled = false
        extraLeftOffset = 16
        extraRightOffset = 16
        
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 12)
        xAxis.labelTextColor = UIColor.frameworkAsset(named: "AirGray")
        xAxis.axisLineColor = .blue
        xAxis.setLabelCount(4, force: true)
        xAxis.drawGridLinesEnabled = false
        xAxis.valueFormatter = HourlyAxisValueFormatter()
        
        leftAxis.drawLabelsEnabled = false
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawZeroLineEnabled = false
    }
    
    func updateAppearance(
        xMin: TimeInterval,
        xMax: TimeInterval,
        yMin: Double,
        yMax: Double
    ) {
        xAxis.axisMinimum = xMin
        xAxis.axisMaximum = xMax
        leftAxis.axisMinimum = yMin - abs(yMin * 0.1)
        leftAxis.axisMaximum = yMax + abs(yMin * 0.1)
    }
}

//public class HourlyValueFormatter: IValueFormatter {
//    public func stringForValue(
//        _ value: Double,
//        entry: ChartDataEntry,
//        dataSetIndex: Int,
//        viewPortHandler: ViewPortHandler?
//    ) -> String {
//        return service(ChartInteractor.self).hourlyString(timeInterval: value)
//    }
//}

extension LineChartDataSet {
    func applyAppearance() {
        drawCirclesEnabled = false
        lineWidth = 1
        setColor(.systemBlue)
        fill = Fill(color: .cyan)
        fillAlpha = 0.1
        drawFilledEnabled = true
        highlightEnabled = true
        drawVerticalHighlightIndicatorEnabled = false
        drawHorizontalHighlightIndicatorEnabled = false
        drawValuesEnabled = false
        mode = .linear
    }
}
//
//class PillMarker: MarkerImage {
//    
//    public var min: TimeInterval?
//
//    private (set) var color: UIColor
//    private (set) var font: UIFont
//    private (set) var textColor: UIColor
//    private var labelText: String = ""
//    private var attrs: [NSAttributedString.Key: AnyObject]!
//
//    static let formatter: DateComponentsFormatter = {
//        let f = DateComponentsFormatter()
//        f.allowedUnits = [.minute, .second]
//        f.unitsStyle = .short
//        return f
//    }()
//
//    init(color: UIColor, font: UIFont, textColor: UIColor) {
//        self.color = color
//        self.font = font
//        self.textColor = textColor
//
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .center
//        attrs = [.font: font, .paragraphStyle: paragraphStyle, .foregroundColor: textColor, .baselineOffset: NSNumber(value: -4)]
//        super.init()
//    }
//
//    override func draw(context: CGContext, point: CGPoint) {
//        // custom padding around text
//        let labelWidth = labelText.size(withAttributes: attrs).width + 10
//        // if you modify labelHeigh you will have to tweak baselineOffset in attrs
//        let labelHeight = labelText.size(withAttributes: attrs).height + 4
//
//        // place pill above the marker, centered along x
//        var rectangle = CGRect(x: point.x, y: point.y, width: labelWidth, height: labelHeight)
//        rectangle.origin.x -= rectangle.width / 2.0
//        let spacing: CGFloat = 20
//        rectangle.origin.y -= rectangle.height + spacing
//
//        // rounded rect
//        let clipPath = UIBezierPath(roundedRect: rectangle, cornerRadius: 6.0).cgPath
//        context.addPath(clipPath)
//        context.setFillColor(UIColor.white.cgColor)
//        context.setStrokeColor(UIColor.black.cgColor)
//        context.closePath()
//        context.drawPath(using: .fillStroke)
//
//        // add the text
//        labelText.draw(with: rectangle, options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
//    }
//
//    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
//        labelText = customString(entry.x)
//    }
//
//    private func customString(_ value: Double) -> String {
//        let baseline = min ?? 0
//        let formattedString = PillMarker.formatter.string(
//            from: TimeInterval(value) - baseline
//        )!
//        // using this to convert the left axis values formatting, ie 2 min
//        return "\(formattedString)"
//    }
//}
