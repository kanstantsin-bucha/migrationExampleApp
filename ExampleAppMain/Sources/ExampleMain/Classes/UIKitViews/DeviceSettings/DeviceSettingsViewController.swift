import UIKit

class DeviceSettingsViewController: UIViewController {
    @IBOutlet weak var deviceNameField: UITextField!
    @IBOutlet weak var deviceTokenLabel: UILabel!
    var viewModel: DeviceSettingsViewModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let model = viewModel else { return }
        deviceNameField.text = model.name
        deviceTokenLabel.text = model.token
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel?.syncDevice(name: deviceNameField.text)
        super.viewWillDisappear(animated)
    }
}
