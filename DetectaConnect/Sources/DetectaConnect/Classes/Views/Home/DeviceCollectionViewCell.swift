//
//  DeviceCollectionViewCell.swift
//  DetectaConnect
//
//  Created by Konstantin Bucha on 4/11/21.
//

import UIKit

class DeviceCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var title: UILabel!
    private(set) var deviceId: String?
    
    func update(withDevice device: Device) {
        deviceId = device.id
        title.text = device.name + " " + device.token.prefix(4)
    }
}
