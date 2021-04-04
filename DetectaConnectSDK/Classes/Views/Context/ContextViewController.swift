//
//  ContextViewController.swift
//  BlueSwift
//
//  Created by Kanstantsin Bucha on 4.04.21.
//

import UIKit

class ContextViewController: UIViewController {
    @IBOutlet var valueView1: ValueView!
    @IBOutlet var valueView2: ValueView!
    @IBOutlet var valueView3: ValueView!
    @IBOutlet var valueView4: ValueView!
    @IBOutlet var valueView5: ValueView!
    @IBOutlet var valueView6: ValueView!
    @IBOutlet var iaqValueLabel: UILabel!
    
    private var temperatureModel: ValueUnitModel = TemperatureValueUnitModel()
    private var humidityModel: ValueUnitModel = HumidityValueUnitModel()
    private var pressureModel: ValueUnitModel = HumidityValueUnitModel()
    private var coPpmModel: ValueUnitModel = HumidityValueUnitModel()
    private var co2Model: ValueUnitModel = HumidityValueUnitModel()
    private var vocModel: ValueUnitModel = HumidityValueUnitModel()
    private var valueViews: [ValueView] = []
    
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
        valueViews = [ valueView1, valueView2, valueView3, valueView4, valueView5, valueView6]
        valueView1.add(model: temperatureModel)
        valueView2.add(model: humidityModel)
        valueView3.add(model: pressureModel)
        valueView4.add(model: coPpmModel)
        valueView5.add(model: co2Model)
        valueView6.add(model: vocModel)
    }
    
    private func update() {
        guard isUpdating else { return }
        onMain(afterSeconds: 10) { [weak self] in
            self?.update()
        }
        fetch()
    }
    
    private func fetch() {
        service(GatesKeeper.self).cloudGate.fetchLastContext()
            .onSuccess { [weak self] result in
                guard let context = result.data.first?.context else {
                    return
                }
                self?.temperatureModel.update(value: context.tempCelsius)
                self?.humidityModel.update(value: context.humidity)
                self?.pressureModel.update(value: Float(context.pressureKPa))
                self?.coPpmModel.update(value: context.coPpm)
                self?.co2Model.update(value: context.coPpm)
                self?.vocModel.update(value: context.coPpm)
                onMain {
                    self?.iaqValueLabel.text = String(format: "%.0f", context.iaq)
                    self?.valueViews.forEach { view in
                        view.refresh()
                    }
                }
            }
            .onFailure { error in
                onMain {
                    service(AlertRouter.self).show(error: error)
                }
            }
    }
    
}
