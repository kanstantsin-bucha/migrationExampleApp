//
//  ContextViewController.swift
//  BlueSwift
//
//  Created by Kanstantsin Bucha on 4.04.21.
//

import UIKit

class ContextViewController: UIViewController {
    @IBOutlet var iaqValueLabel: UILabel!
    @IBOutlet weak var iaqImageView: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet var valueViews: [ValueView]!
    
    var token: String!
    
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
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        onMain {
            self.isUpdating = false
        }
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Private method
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == View.a.TimeSpan.id {
            let viewController = segue.destination as! TimeSpanViewController
            viewController.model = TimeSpanViewModel(token: token)
        }
    }

    private func updateIcon(state: UnitValueState) {
        self.iaqImageView.image = (#imageLiteral(resourceName: "detecta-medium") as FrameworkAsset).image.withTintColor(
            .with(state: self.iaqModel.state)
        )
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
        service(GatesKeeper.self).cloudGate.fetchLastContext(token: token)
            .onSuccess { [weak self] result in
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
