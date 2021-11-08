//
//  AlertRouter.swift
//  client
//
//  Created by Kanstantsin Bucha on 8.03.21.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import UIKit

public protocol AlertRouter {
    /// Shows Localised Error on UI
    /// - Parameter error: Error that should implement LocalizedError
    func show(error: Error)
}

class DefaultAlertRouter: AlertRouter {
    func show(error: Error) {
        if !(error is LocalizedError) {
            log.error("Error is not localised: \(error)")
        }
        let controller = UIAlertController(
            title: "Error occurs",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        controller.addAction(
            UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        )
        service(AppRouter.self).showAlert(controller)
    }
}
