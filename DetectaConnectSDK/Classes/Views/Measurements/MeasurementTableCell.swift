//
//  MeasurementTableCell.swift
//  client
//
//  Created by bucha on 6/23/19.
//  Copyright © 2019 Detecta Group. All rights reserved.
//

import Foundation
import UIKit

class MeasurementTableCell: UITableViewCell {
    
    @IBOutlet weak var coField: UILabel!
    @IBOutlet weak var envField: UILabel!
    @IBOutlet weak var debugField: UILabel!
    
    func setUp(values: ContextValues) {
        
        coField.text =
            String(format: "%.2fppm", values.coPpm)
        
        envField.text =
            String(format: "T: %.2fC, ", values.tempCelsius) +
            String(format: "H: %.2f%%, ", values.humidity) +
            String(format: "P: %.0fHPa", values.pressureHpa)
        
        debugField.text = String(
                format: "co2: %.2f, iaq: %.2f, voc: %.2f",
                values.co2Equivalent, values.iaq, values.breathVocEquivalent
            )
    }
    
}
