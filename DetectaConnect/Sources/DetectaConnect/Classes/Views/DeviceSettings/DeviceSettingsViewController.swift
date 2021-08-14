//
//  DeviceSettingsViewController.swift
//  BlueSwift
//
//  Created by Konstantin on 7/25/21.
//

import UIKit

class DeviceSettingsViewController: UIViewController {
    @IBOutlet weak var deviceNameField: UITextField!
    var viewModel: DeviceSettingsViewModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let model = viewModel else { return }
        deviceNameField.text = model.deviceName
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel?.syncDevice(name: deviceNameField.text)
        super.viewWillDisappear(animated)
    }
}
