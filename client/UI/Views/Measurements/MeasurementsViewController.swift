//
//  MeasurementsViewController.swift
//  Client iOS
//
//  Created by Kanstantsin Bucha on 8/17/18.
//  Copyright © 2019 Detecta Group. All rights reserved.
//

import UIKit

final class MeasurementsViewController: UIViewController {
    
    @IBOutlet weak var startStopButton: UIButton!
    
    @IBOutlet weak var table: UITableView!
    var data: [ContextValues] = []
    
    @IBOutlet weak var pressureField: UILabel!
    @IBOutlet weak var humidityField: UILabel!
    @IBOutlet weak var tempField: UILabel!
    @IBOutlet weak var coField: UILabel!
    
    private let cellId = "Prototype"
    private var notificationToken: AnyObject?
    
    //MARK: - Actions
    
    @IBAction private func didTouchPreferences(sender: UIButton) {
    }
    
    @IBAction private func didTouchClear(sender: UIButton) {
        self.data = []
        self.table.reloadData()
    }
    
    //MARK: - life cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        try? gatesKeeper.bleGate.open()
        table.reloadData()
        subscribeToNotifications()
        updateStartStopButtonState()
        _ = becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        unsubscribeFromNotification()
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        if motion == .motionShake {
            
            gatesKeeper.bleGate.close()
            try? gatesKeeper.bleGate.open()
            updateStartStopButtonState()
        }
    }
    
    //MARK: - logic -
    
    private func subscribeToNotifications() {
        
        notificationToken = NotificationCenter.default.addObserver(
            forName: Constant.Notifications.ContextUpdate.name,
            object: nil,
            queue: nil) { [weak self] notification in
            
            guard let self = self else { return }
            
            guard let update = notification.userInfo?[Constant.Notifications.ContextUpdate.values],
                  let contextValues = update as? ContextValues else {
                
                return
            }
            
            self.handleContextChange(values: contextValues)
        }
    }
    
    private func unsubscribeFromNotification() {
        
        if let token = notificationToken {
            
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    private func setupTable() {
        table.delegate = self;
        table.dataSource = self;
    }
    
    @IBAction private func didTouchStop(sender: UIButton) {
        
        if  gatesKeeper.bleGate.isOpen {
            gatesKeeper.bleGate.close()
        }
        else {
            try? gatesKeeper.bleGate.open()
        }
        
        updateStartStopButtonState()
    }
    
    private func updateStartStopButtonState() {
        
        let title = gatesKeeper.bleGate.isOpen ? "Stop" : "Start"
        startStopButton.setTitle(title, for: .normal)
    }
    
    private func handleContextChange(values: ContextValues) {
        
        print("MeasurementsViewController handleContextChange \(values)")
        
        updateFields(values: values)
        
        let newIndexPath = IndexPath(row: 0, section: 0)
        data.insert(values, at: 0)
        table.insertRows(
            at: [newIndexPath],
            with: .automatic)
    }
    
    func updateFields(values: ContextValues) {
        
        coField.text = "\(String(format: "%.0f", values.coPpm))"
        tempField.text = "\(String(format: "%.1fC", values.tempCelsius))"
        humidityField.text = "\(String(format: "%.1f%%", values.humidity))"
        pressureField.text = "\(String(format: "%.0fPa", values.pressurePa))"
    }
}

extension MeasurementsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MeasurementTableCell
        if let reusedCell = tableView.dequeueReusableCell(withIdentifier: cellId) as? MeasurementTableCell {
            cell = reusedCell
        }
        else {
            cell = MeasurementTableCell()
        }
        cell.setUp(values: data[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
