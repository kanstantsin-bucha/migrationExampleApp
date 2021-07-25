//
//  ValueView.swift
//  DetectaConnectSDK
//
//  Created by Kanstantsin Bucha on 4.04.21.
//

import UIKit

class RoundView: UIView {
    override var bounds: CGRect {
        didSet {
            // Make it round
            layer.cornerRadius = frame.size.width / 2
        }
    }
}

class ValueView: UIView {
    private var contentView: UIView!
    private var model: UnitValueModel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var roundView: RoundView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let nibName = String(describing: type(of: self))
        contentView = ViewFactory.loadView(nibName: nibName, owner: self)
        contentView.frame = self.bounds
        self.addSubview(contentView)
    }
    
    func add(model: UnitValueModel) {
        self.model = model
        
        unitLabel.text = model.unit.unit
        titleLabel.text = model.unit.title
    }
    
    func refresh() {
        valueLabel.text = model.value
        roundView.layer.borderColor = UIColor.with(state: model.state).cgColor
    }
}
