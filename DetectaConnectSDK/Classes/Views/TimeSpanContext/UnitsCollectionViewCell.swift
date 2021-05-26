//
//  UnitsCollectionViewCell.swift
//  DetectaConnectSDK
//
//  Created by Konstantin on 5/26/21.
//

import UIKit

class UnitsCollectionViewCell: UICollectionViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var background: UIView!
    
    var isActive = false {
        didSet {
            let color: UIColor
            if isActive {
                color = .frameworkAsset(named: "AirBlue")
            } else {
                color = .frameworkAsset(named: "AirGray_K30")
            }
            background.backgroundColor = color
        }
    }
    
    override func prepareForReuse() {
        title.text = nil
        isActive = false
    }
}
