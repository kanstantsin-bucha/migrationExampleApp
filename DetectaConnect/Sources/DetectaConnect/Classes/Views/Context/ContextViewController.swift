//
//  ContextViewController.swift
//  BlueSwift
//
//  Created by Kanstantsin Bucha on 4.04.21.
//

import UIKit
import Sentry

class ContextViewController: UIViewController {
    @IBOutlet var iaqValueLabel: UILabel!
    @IBOutlet weak var iaqImageView: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet var valueViews: [ValueView]!
    @IBOutlet var deviceTitleLabel: UILabel!
    private var deviceContainer: DeviceContainer!
    
    public func apply(deviceContainer: DeviceContainer) {
        self.deviceContainer = deviceContainer
    }
    
    private var iaqModel: UnitValueModel = IAQValueUnitModel()
    private var unitValueModels: [UnitValueModel] = [
        TemperatureValueUnitModel(),
        HumidityValueUnitModel(),
        PressureValueUnitModel(),
        CO2ValueUnitModel(),
        COValueUnitModel(),
        VocValueUnitModel()
    ]
    
    private var isUpdating = false
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy\nHH:mm"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onMain {
            self.isUpdating = true
            self.update()
            self.updateIcon(state: .good)
            self.deviceTitleLabel.text = self.deviceContainer.device.name
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        onMain {
            self.isUpdating = false
            self.deviceContainer?.clearCache()
        }
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Private method
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == View.a.TimeSpan.id {
            guard let viewController = segue.destination as? TimeSpanViewController else {
                preconditionFailure(#fileID + "Segue destination is not a kind of TimeSpanViewController")
            }
            viewController.model = TimeSpanViewModel(token: deviceContainer.device.token)
        }
        if segue.identifier == View.a.DeviceSettings.id {
            guard let viewController = segue.destination as? DeviceSettingsViewController else {
                preconditionFailure(#fileID + "Segue destination is not a kind of DeviceSettingsViewController")
            }
            viewController.viewModel = DeviceSettingsViewModel(deviceContainer: deviceContainer)
        }
    }

    private func updateIcon(state: UnitValueState) {
        self.iaqImageView.tintColor = .with(state: self.iaqModel.state)
        self.iaqImageView.image = (#imageLiteral(resourceName: "detecta-medium") as FrameworkAsset).image.withRenderingMode(.alwaysTemplate)
    }
    
    private func configure() {
        valueViews.enumerated().forEach { (index, valueView) in
            valueView.add(model: unitValueModels[index])
        }
    }
    
    private func update() {
        guard isUpdating else { return }
        onMain(afterSeconds: 10) { [weak self] in
            self?.update()
        }
        fetch()
    }
    
    private func fetch() {
        let event = Event()
        event.eventId = SentryId()
        event.message = SentryMessage(formatted: "Last context fetch")
        event.startTimestamp = Date()
        event.type = "transaction"
        event.transaction = "Context fetch"
        service(GatesKeeper.self).cloudGate.fetchLastContext(token: deviceContainer.device.token)
            .onSuccess { [weak self] result in
                event.timestamp = Date()
                SentrySDK.capture(event: event)
                guard let self = self, let wrapper = result.data.first else {
                    return
                }
                let timestamp = self.dateFormatter.string(from: wrapper.created)
                self.unitValueModels.forEach { model in
                    model.apply(contextWrapper: wrapper)
                }
                self.iaqModel.apply(contextWrapper: wrapper)
                onMain {
                    self.iaqValueLabel.text = self.iaqModel.value
                    self.updateIcon(state: self.iaqModel.state)
                    self.timestampLabel.text = timestamp
                    self.valueViews.forEach { $0.refresh() }
                }
            }
            .onFailure { error in
                onMain {
                    service(AlertRouter.self).show(error: error)
                }
            }
    }
}
