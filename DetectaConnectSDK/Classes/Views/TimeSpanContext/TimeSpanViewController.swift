//
//  TimeSpanViewController.swift
//  DetectaConnectSDK
//
//  Created by Konstantin on 4/27/21.
//

import Charts
import Combine
import UIKit

class TimeSpanViewController: UIViewController {
    var model: TimeSpanViewModel!
    
    var token: String!
    
    @IBOutlet weak var lineChartView: LineChartView!
    // Badge View
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    // Characteristics View
    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var averageValueLabel: UILabel!
    @IBOutlet weak var maxValueLabel: UILabel!
    // Toggle button
    @IBOutlet weak var toggleIntervalButton: UIButton!
    

    private var cancellable: AnyCancellable?
    
    deinit {
        cancellable?.cancel()
    }
    
    // MARK: - Actions
    
    @IBAction func toggleIntervalButtonDidTouch() {
        model.toggleInterval()
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
        model.viewWillAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        cancellable?.cancel()
        cancellable = nil
        service(AppRouter.self).hideSpinner()
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Private method
    
    private func configure() {
        cancellable = model.stateSubject.sink { [weak self] state in
            onMain {
                log.event("update state: \(state)")
                guard let self = self else { return }
                
                switch state {
                case .undefined:
                    log.error("Undefined state was propagated to the view")
                    // Should not be called
                    break
                    
                case .loading:
                    self.view.isUserInteractionEnabled = false
                    service(AppRouter.self).showSpinner()
                    self.updateIntervalTitle()
                    self.updateBadge(entry: nil)
                    self.updateCharacteristics(min: 0, max: 0, average: 0)
                
                case .failed:
                    self.view.isUserInteractionEnabled = true
                    service(AppRouter.self).hideSpinner()
                    self.updateIntervalTitle()
                    self.updateBadge(entry: nil)
                    self.update(data: nil)
                    
                case let .updated(data):
                    self.view.isUserInteractionEnabled = true
                    service(AppRouter.self).hideSpinner()
                    self.updateIntervalTitle()
                    self.updateBadge(entry: data.badgeEntry)
                    self.update(data: data)
                }
            }
        }
        lineChartView.applyAppearance()
        lineChartView.delegate = self
    }
    
    private func update(data: EnhancedChartData?) {
        guard let data = data else {
            updateCharacteristics(min: 0, max: 0, average: 0)
            lineChartView.data = nil
            return
        }
        updateCharacteristics(min: data.data.yMin, max: data.data.yMax, average: data.xAverage)
        lineChartView.data = data.data
        lineChartView.updateAppearance(
            xMin: data.xMin,
            xMax: data.xMax,
            yMin: data.data.getYMin(),
            xSpanCount: data.xSpanCount)
        lineChartView.animate(xAxisDuration: 1)
    }
    
    private func updateIntervalTitle() {
        toggleIntervalButton.setTitle(model.intervalTitle, for: .normal)
    }
    
    private func updateBadge(entry: ChartDataEntry?) {
        let (value, color, unit, time) = model.badge(x: entry?.x, y: entry?.y)
        unitLabel.text = unit
        valueLabel.text = value
        valueLabel.textColor = color
        timeLabel.text = time
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












