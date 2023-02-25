import UIKit

class ContextViewModel {
    let deviceID: String
    var observeContext: Observe<String>?
    var deviceToken: String { device?.token ?? "" }
    var deviceName: String { device?.name ?? "" }
    private(set) lazy var evaluationGroup: EvaluationGroup =
        service(EnvironmentRisksEvaluator.self).createEvaluationGroup()
    private(set) lazy var mainModel: ValueUnitModel = evaluationGroup.valueModels[0]
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy\nHH:mm"
        return formatter
    }()
    private var device: Device?
    private var isUpdating = false
    
    init(deviceID: String) {
        self.deviceID = deviceID
    }
    
    public func onViewWillAppear() {
        device = service(DevicePersistence.self).load(id: deviceID)
        update()
    }
    
    // MARK: - Private methods
    
    private func update() {
        guard !isUpdating else { return }
        onMain(afterSeconds: 10) { [weak self] in
            self?.update()
        }
        fetch()
    }
    
    private func fetch() {
        guard let token = device?.token else { return }
        isUpdating = true
        service(GatesKeeper.self).cloudGate
            .fetchLastContext(token: token)
            .onSuccess { [weak self] response in
                guard let self = self else { return }
                guard case let .newData(wrapper) = response else {
                    log.error("Cloud fetch failed to return new data")
                    return
                }
                self.evaluationGroup.apply(context: wrapper.data)
                self.observeContext?(self.dateFormatter.string(from: wrapper.created))
                onMain { [weak self] in
                    self?.isUpdating = false
                }
            }
            .onFailure { error in
                onMain { [weak self] in
                    self?.isUpdating = false
                    service(AlertRouter.self).show(error: error)
                }
            }
    }
}

class ContextViewController: UIViewController {
    @IBOutlet var iaqValueLabel: UILabel!
    @IBOutlet weak var iaqImageView: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet var valueViews: [ValueView]!
    @IBOutlet var deviceTitleLabel: UILabel!
    
    var viewModel: ContextViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateIcon(state: .good)
        viewModel.onViewWillAppear()
        deviceTitleLabel.text = viewModel.deviceName
        viewModel.onViewWillAppear()
    }
    
    // MARK: - Private methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ViewType.a.TimeSpan.id {
            guard let viewController = segue.destination as? TimeSpanViewController else {
                preconditionFailure(#fileID + "Segue destination is not a kind of TimeSpanViewController")
            }
            viewController.model = TimeSpanViewModel(token: viewModel.deviceToken)
        }
        if segue.identifier == ViewType.a.DeviceSettings.id {
            guard let viewController = segue.destination as? DeviceSettingsViewController else {
                preconditionFailure(#fileID + "Segue destination is not a kind of DeviceSettingsViewController")
            }
            viewController.viewModel = DeviceSettingsViewModel(deviceID: viewModel.deviceID)
        }
    }

    private func updateIcon(state: UnitValueState) {
        iaqImageView.tintColor = .with(state: viewModel.mainModel.state)
        iaqImageView.image = (#imageLiteral(resourceName: "detecta-medium") as FrameworkAsset).image.withRenderingMode(.alwaysTemplate)
    }
    
    private func configure() {
        let requiredUnitsCount = valueViews.count + 1
        let group = viewModel.evaluationGroup
        guard group.valueModels.count >= requiredUnitsCount else {
            log.error("Evaluation group have less than \(requiredUnitsCount) units")
            return
        }
        // we skip main unit model (index: 0) cause it has it's own way to display value
        valueViews.enumerated().forEach { (index, valueView) in
            valueView.add(model: group.valueModels[index + 1])
        }
        
        viewModel.observeContext = { [weak self] timestamp in
            guard let self else { return }
            self.iaqValueLabel.text = self.viewModel.mainModel.value
            self.updateIcon(state: self.viewModel.mainModel.state)
            self.timestampLabel.text = timestamp
            self.valueViews.forEach { $0.refresh() }
        }
    }
}
