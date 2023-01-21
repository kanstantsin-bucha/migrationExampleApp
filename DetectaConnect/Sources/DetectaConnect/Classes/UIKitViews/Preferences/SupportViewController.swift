//
//  SupportViewController.swift
//  Client iOS
//
//  Created by Kanstantsin Bucha on 8/17/18.
//  Copyright © 2019 Detecta Group. All rights reserved.
//

import UIKit

class SupportViewController: UIViewController {
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var supportButton: UIButton!
    
    //MARK: - life cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func supportDidTouch(sender: UIButton) {
        service(AppRouter.self).openSupportLink()
    }
    
    @IBAction func linkDidTouch(_ sender: UIButton) {
        service(AppRouter.self).openAppLink()
    }
}
