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
    @IBOutlet var goB: UIButton!
    
    private var isPendingConnection = false
    private let longPressGestureRecognizer = UILongPressGestureRecognizer()
    
    // MARK: - Actions
    
    @IBAction func goButtonDidTouch(sender: UIButton) {
        service(AppRouter.self).showSpinner()
        goB.isEnabled = false
        log.user("Go Button Did Touch")
        _ = service(GuideInteractor.self).connectBleDeviceWifi(
            ssid: ssidField.text ?? "",
            pass: passField.text ?? ""
        ).onFailure { error in
            service(AlertRouter.self).show(error: error)
        }.onSuccess { [weak self] _ in
            onMain {
                self?.dismiss(animated: true, completion: nil)
            }
        }.finally { [weak self] in
            onMain {
                service(AppRouter.self).hideSpinner()
                self?.goB.isEnabled = true
            }
        }
    }
    
    @objc func viewDidLongPress(sender: UILongPressGestureRecognizer) {
        let alert = UIAlertController(title: "Set Default", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Minsk", style: .default) { _ in
            self.ssidField.text = "HUAWEI-zdDx"
            self.passField.text = "485754438DEEBE9D"
        })
        alert.addAction(UIAlertAction(title: "Vienna", style: .default) { _ in
            self.ssidField.text = "A1-C2618C"
            self.passField.text = "PVTH6268RL"
        })
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel) { _ in })
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        longPressGestureRecognizer.addTarget(self, action: #selector(viewDidLongPress(sender:)))
        view.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        service(GatesKeeper.self).bleGate.open()
        checkDevice()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        service(AppRouter.self).hideSpinner()
        service(GatesKeeper.self).bleGate.close()
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
