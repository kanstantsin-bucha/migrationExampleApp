//
//  ValueView.swift
//  DetectaConnectSDK
//
//  Created by Kanstantsin Bucha on 4.04.21.
//

import UIKit

class ValueView: UIView {
    private var contentView: UIView!
    private var model: ValueUnitModel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let nibName = String(describing: type(of: self))
        contentView = ViewFactory.loadView(nibName: nibName, owner: self)
        contentView.frame = self.bounds
        contentView.layer.cornerRadius = 30
        self.addSubview(contentView)
    }
    
    func add(model: ValueUnitModel) {
        self.model = model
        
        unitLabel.text = model.unit
        titleLabel.text = model.title
    }
    
    func refresh() {
        valueLabel.text = model.value
    }
}
