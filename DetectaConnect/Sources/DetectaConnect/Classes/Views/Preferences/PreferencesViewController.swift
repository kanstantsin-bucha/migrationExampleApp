//
//  UserPreferencesViewController.swift
//  Client iOS
//
//  Created by Kanstantsin Bucha on 8/17/18.
//  Copyright © 2019 Detecta Group. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let willShow = #selector(PreferencesViewController.keyboardWillShow(notification:))
    static let willHide = #selector(PreferencesViewController.keyboardWillHide(notification:))
}

class PreferencesViewController: UIViewController {
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var scrollContent: UIView!
    @IBOutlet weak var scrollPlaceholder: UIView!
    @IBOutlet weak var wifiStatus: UILabel!
    @IBOutlet weak var wifiEnabled: UISwitch!
    @IBOutlet weak var wifiNetInfoField: UILabel!
    
    private weak var activeField: UITextField?
    private let fieldToKeyboardMinimalDistance: CGFloat = 22
    private var scrollBottomMargin: CGFloat = 0
    
    // MARK: - actions
    
    @IBAction private func sendWifiCredsDidTouch(sender: UIButton) {
    }
    
    @objc private func save(sender: UIButton) {
    }
    
    @objc private func cancel(sender: UIButton) {
    }
    
    //MARK: - life cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFields()
    
        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(onUserTapOnFreeSpace(sender:)))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        populateDataWithBle()
        registerKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //content height vaild only after viewDidAppear
        scrollBottomMargin = max(0, scroll.bounds.height - scroll.contentSize.height)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default
            .removeObserver(self)
    }
    
    //MARK: - Private methods
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        }
        return .default
    }
    
    @objc func onUserTapOnFreeSpace(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    private func populateDataWithBle() {
//        infoObservigHandle = gatesKeeper
//            .bleGate
//            .wifiNetInfoObserver.addObserving {
//            [weak self] (info, error) in
//                guard let self = self,
//                    let info = info else {
//                        return
//                }
//                self.wifiNetInfoField.text = info.ipAndName
//            }
//        statusObservigHandle = gatesKeeper
//            .bleGate
//            .wifiStatusObserver.addObserving {
//                [weak self] (status, error) in
//                guard let self = self,
//                    let status = status else {
//                        return
//                }
//                self.wifiStatus.text = String(describing: status)
//        }
    }
    
//    private func harvestData() -> ThingData {
//        let result = ThingData(apName: apNameField.text ?? "",
//                               apPass: apPassField.text ?? "",
//                               isWifiEnabled: wifiEnabled.isOn,
//                               measurementInterval: UInt8(measurementIntervalField.text ?? "3") ?? 3,
//                               isMeasurementEnabled: measurementEnabled.isOn,
//                               isNotificationsEnabled: notificationEnabled.isOn)
//        return result
//    }
    
//    private func acceptData(_ data: ThingData?) {
//        apNameField.text = data?.apName
//        apPassField.text = data?.apPass
//        wifiEnabled.isOn = data?.isWifiEnabled ?? true
//        if let interval = data?.measurementInterval {
//            measurementIntervalField.text =  String(interval)
//        }
//        else {
//            measurementIntervalField.text = "3"
//        }
//        measurementEnabled.isOn = data?.isMeasurementEnabled ?? true
//        notificationEnabled.isOn = data?.isNotificationsEnabled ?? true
//    }
//
//    private func setupButtons() {
//        saveButton.addTarget(self,
//                             action: #selector(save(sender:)),
//                             for: .touchUpInside)
//        cancelButton.addTarget(self,
//                               action: #selector(cancel(sender:)),
//                               for: .touchUpInside)
//    }
    
    private func setupFields() {
    }
    
    private func registerKeyboardNotifications() {
        
        NotificationCenter.default
            .addObserver(self, selector: .willShow,
                         name: UIResponder.keyboardWillShowNotification,
                         object: nil)
        
        NotificationCenter.default
            .addObserver(self, selector: .willHide,
                         name: UIResponder.keyboardWillHideNotification,
                         object: nil)
    }
    
    private func applyScroll(bottomInset: CGFloat, offsetY: CGFloat) {
        
        guard bottomInset >= 0,
            offsetY >= 0 else {
            
            return
        }
        
        var contentInset = scroll.contentInset
        contentInset.bottom = bottomInset
        
        scroll.contentInset = contentInset
        scroll.scrollIndicatorInsets = contentInset
        
        scroll.contentOffset = CGPoint(x: 0, y: offsetY)
    }
    
    private func showWifiApAlert(with message: String) {
        let alert = UIAlertController(
            title: "Ap Preferences",
            message: message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    //MARK - observing -
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let field = activeField else {
            
            print("[Error]: keyboard notification fired but no active field detected")
            return
        }
    
        guard let info = notification.userInfo else {
            
            print("[Error]: keyboard notification has no user info")
            return
        }
        
        guard let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            
            print("[Error]: keyboard notification info has no valid frame")
            return
        }
        
        let scrollKeyboard = scrollPlaceholder.convert(keyboardFrameValue.cgRectValue,
                                                       from: nil)
        
        let visibleArea = scrollKeyboard.minY
        
        let negativeOffset = visibleArea - fieldToKeyboardMinimalDistance - field.frame.maxY
        
        let fieldOffset = -negativeOffset
        
        guard fieldOffset > 0 else {
            
            applyScroll(bottomInset: 0,
                        offsetY: 0)
            return
        }
        
        let overlap = scrollPlaceholder.bounds.height - scrollKeyboard.minY
        
        applyScroll(bottomInset: overlap,
                    offsetY: fieldOffset)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        
        var inset = scroll.contentInset
        inset.bottom = 0.0
        
        scroll.contentInset = inset
        scroll.scrollIndicatorInsets = inset
    }
}

