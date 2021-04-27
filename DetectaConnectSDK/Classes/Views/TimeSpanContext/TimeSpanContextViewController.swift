//
//  TimeSpanContextViewController.swift
//  DetectaConnectSDK
//
//  Created by Konstantin on 4/27/21.
//

import UIKit

class TimeSpanContextViewController: UIViewController {
    var token: String!
    
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
    }
    
    private func update() {
        guard isUpdating else { return }
        fetch()
    }
    
    private func fetch() {
        service(GatesKeeper.self).cloudGate.fetchPeriodContext(
            token: token,
            endDate: Date(),
            period: .oneHour
        )
            .onSuccess { [weak self] result in
                guard let self = self else { return }
                let contextValues = result.data.map { $0.context }
                onMain {
                    log.event("Load values: \(contextValues.count) \(contextValues.first)")
                }
            }
            .onFailure { error in
                onMain {
                    service(AlertRouter.self).show(error: error)
                }
            }
    }
}

