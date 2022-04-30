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
    private lazy var evaluationGroup: EvaluationGroup =
        service(EnvironmentRisksEvaluator.self).createEvaluationGroup()
    
    public func apply(deviceContainer: DeviceContainer) {
        self.deviceContainer = deviceContainer
    }
    
    private lazy var mainModel: ValueUnitModel = evaluationGroup.valueModels[0]
    
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
    
    // MARK: - Private methods
    
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
        self.iaqImageView.tintColor = .with(state: self.mainModel.state)
        self.iaqImageView.image = (#imageLiteral(resourceName: "detecta-medium") as FrameworkAsset).image.withRenderingMode(.alwaysTemplate)
    }
    
    private func configure() {
        let requiredUnitsCount = valueViews.count + 1
        guard evaluationGroup.valueModels.count >= requiredUnitsCount else {
            log.error("Evaluation group have less than \(requiredUnitsCount) units")
            return
        }
        // we skip main unit model (index: 0) cause it has it's own way to display value
        valueViews.enumerated().forEach { (index, valueView) in
            valueView.add(model: evaluationGroup.valueModels[index + 1])
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
                self.evaluationGroup.apply(context: wrapper.context)
                onMain {
                    self.iaqValueLabel.text = self.mainModel.value
                    self.updateIcon(state: self.mainModel.state)
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
