//
//  TimeSpanViewController.swift
//  DetectaConnect
//
//  Created by Konstantin on 4/27/21.
//

import Charts
import Combine
import UIKit
import Sentry

class TimeSpanViewController: UIViewController {
    var model: TimeSpanViewModel!

    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var unitsCollection: UICollectionView!
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
    @IBOutlet weak var noDataView: UIView!
    
    private var unitsState = UnitsState(units: [], selectedIndex: nil)
    
    deinit {
        model.stateSubject.cancel()
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
        SentrySDK.capture(message: "TimeSpanViewController appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        model.stateSubject.cancel()
        service(AppRouter.self).hideSpinner()
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Private method
    
    private func configure() {
        model.stateSubject.subscribe { [weak self] state in
            onMain {
                log.event("update state: \(state)")
                guard let self = self else { return }
                
                switch state {
                case .undefined:
                    log.error("Undefined state was propagated to the view")
                    // Should not be called
                    break
                    
                case let .loading(intervalTitle):
                    self.view.isUserInteractionEnabled = false
                    service(AppRouter.self).showSpinner()
                    self.noDataView.isHidden = true
                    self.updateInterval(title: intervalTitle)
                    self.updateBadge(entry: nil)
                    self.updateCharacteristics(min: 0, max: 0, average: 0)
                
                case .failed:
                    self.view.isUserInteractionEnabled = true
                    service(AppRouter.self).hideSpinner()
                    self.noDataView.isHidden = true
                    self.updateBadge(entry: nil)
                    self.update(data: nil)
                    
                case let .updated(data, unitsState, intervalTitle, isNoData):
                    self.view.isUserInteractionEnabled = true
                    service(AppRouter.self).hideSpinner()
                    self.noDataView.isHidden = !isNoData
                    self.updateInterval(title: intervalTitle)
                    self.updateBadge(entry: data.badgeEntry)
                    self.update(data: data)
                    self.displayUnits(state: unitsState)
                }
            }
        }
        lineChartView.applyAppearance()
        lineChartView.delegate = self
        (unitsCollection.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing = 10
    }
    
    private func update(data: EnhancedChartData?) {
        guard let chartData = data else {
            updateCharacteristics(min: 0, max: 0, average: 0)
            lineChartView.data = nil
            return
        }
        lineChartView.highlightValues(nil)
        lineChartView.data = chartData.data
        guard let data = chartData.data else {
            lineChartView.animate(xAxisDuration: 1)
            return
        }
        updateCharacteristics(min: data.yMin, max: data.yMax, average: chartData.xAverage)
        
        lineChartView.updateAppearance(
            xMin: chartData.xMin,
            xMax: chartData.xMax,
            yMin: data.getYMin(axis: .left),
            yMax: data.getYMax(axis: .left)
        )
        lineChartView.animate(xAxisDuration: 1)
    }
    
    private func updateInterval(title: String) {
        toggleIntervalButton.setTitle(title, for: .normal)
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
    
    private func displayUnits(state: UnitsState) {
        unitsState = state
        unitsCollection.reloadData()
        if let selectedIndex = state.selectedIndex {
            unitsCollection.selectItem(
                at: IndexPath(row: selectedIndex, section: 0),
                animated: true,
                scrollPosition: .centeredHorizontally
            )
        }
        self.title = state.selectedUnit?.title
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

extension TimeSpanViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unitsState.units.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "UnitsCollectionViewCell",
            for: indexPath
        ) as! UnitsCollectionViewCell
        cell.title.text = unitsState.units[indexPath.row].shortTitle
        cell.isActive = unitsState.selectedIndex == indexPath.row
        return cell
    }
}

extension TimeSpanViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        model.select(unit: unitsState.units[indexPath.row])
    }
}












