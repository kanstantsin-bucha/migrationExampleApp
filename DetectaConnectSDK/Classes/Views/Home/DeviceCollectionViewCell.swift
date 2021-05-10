//
//  DeviceCollectionViewCell.swift
//  DetectaConnectSDK
//
//  Created by Konstantin Bucha on 4/11/21.
//

import UIKit

class DeviceCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var title: UILabel!
    private(set) var token: String?
    
    func update(withDevice device: Device) {
        token = device.token
        title.text = device.name + " " + device.token.prefix(4)
    }
}
