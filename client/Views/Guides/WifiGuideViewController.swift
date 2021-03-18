//
//  WifiGuideViewController.swift
//  client
//
//  Created by Kanstantsin Bucha on 5.03.21.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import UIKit

final class WifiGuideViewController: UIViewController {
    @IBOutlet var ssidField: UITextField!
    @IBOutlet var passField: UITextField!
    
    private var isPendingConnection = false
    
    // MARK: - Actions
    
    @IBAction func goButtonDidTouch(sender: UIButton) {
        log.user("Go Button Did Touch")
        _ = service(GuideInteractor.self).connectBleDeviceWifi(
            ssid: ssidField.text ?? "",
            pass: passField.text ?? ""
        ).onFailure { error in
            service(AlertRouter.self).show(error: error)
        }.onSuccess { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkDevice()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        service(AppRouter.self).hideSpinner()
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Private methods
    
    private func checkDevice() {
        log.debug("Check Connected Device")
        if service(GuideInteractor.self).checkConnectedDevice() {
            updatePendingConnection(false)
        } else {
            updatePendingConnection(true)
            onMain(afterSeconds: 3) { [weak self] in
                self?.checkDevice()
            }
        }
    }
    
    private func updatePendingConnection(_ isPending: Bool) {
        log.debug("Update pending connection: \(isPendingConnection), \(isPending)")
        switch (previous: isPendingConnection, incoming: isPending) {
        case (true, true): break
            
        case (false, false): break
            
        case (true, false):
            service(AppRouter.self).hideSpinner()
            ssidField.becomeFirstResponder()
            
        case (false, true):
            service(AppRouter.self).showSpinner()
        }
        isPendingConnection = isPending
    }
}
