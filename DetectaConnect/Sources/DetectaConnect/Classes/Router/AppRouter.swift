//
//  AppRouter.swift
//  client
//
//  Created by Kanstantsin Bucha on 8.03.21.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import UIKit


@available(iOSApplicationExtension, unavailable)
class AppRouter: Service {
    private var root = UIViewController()
    
    public func start(window: UIWindow) {
        setupAppearance()
        let controller = ViewFactory.loadView(id: View.root)
        ((controller as? UINavigationController)?.navigationBar.barStyle = .black)
        root = controller
        window.rootViewController = controller
        window.backgroundColor = .white
    }
    
    // MARK: - Private methods
    
    private func setupAppearance() {
        let titleColor = UIColor.frameworkAsset(named: "AirGray_K30")
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: titleColor,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
        ]
    }
    
    private var spinnerStyle: UIActivityIndicatorView.Style {
        if #available(iOS 13.0, *) {
            return .large
        }
        return .medium
    }
    
    private var spinnerSuperview: UIView? {
        return topViewController()?.view
    }
    private var spinnerView: UIView?
    
    public func openSupportLink() {
        UIApplication.shared.open(
            Constant.AppLink.supportUrl,
            options: [:],
            completionHandler: nil
        )
    }
    
    public func openAppLink() {
        UIApplication.shared.open(
            Constant.AppLink.siteUrl,
            options: [:],
            completionHandler: nil
        )
    }
    
    public func showAlert(_ alert: UIAlertController) {
        log.operation("Show alert")
        guard alert.actions.count > 0 else {
            log.error("The alert have no actions")
            log.failure("Show alert")
            return
        }
        guard let topController = topViewController() else {
            log.error("No top view controller")
            log.failure("Show alert")
            return
        }
        onMain {
            topController.present(alert, animated: true, completion: nil)
            log.success("Show alert")
        }
    }
    
    public func showSpinner() {
        log.operation("Show spinner")
        guard spinnerView == nil else {
            log.cancel("Show spinner - it is already shown")
            return
        }
        guard let view = spinnerSuperview else {
            log.error("No super view to show")
            log.failure("Show spinner")
            return
        }
       
        let spinner = UIActivityIndicatorView(style: spinnerStyle)
        spinner.color = .darkGray
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.alpha = 0
        
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        spinnerView = spinner
        
        spinner.startAnimating()
        UIView.animate(withDuration: 1.0) {
            spinner.alpha = 1
        }
        log.success("Show spinner")
    }
    
    public func hideSpinner() {
        log.operation("Hide spinner")
        guard let spinner = spinnerView else {
            log.warning("No spinner while hide called")
            log.cancel("Hide spinner - no spinner is shown")
            return
        }
        
        spinnerView = nil
        UIView.animate(withDuration: 1.0) {
            spinner.alpha = 0
        } completion: { _ in
            spinner.removeFromSuperview()
        }
        
        log.success("Hide spinner")
    }
    
    // MARK: - Private methods
    
    private func topViewController(
        controller: UIViewController? = nil
    ) -> UIViewController? {
        let controller = controller ?? root
        guard let next = next(controller: controller),
              !(next is UIAlertController) else {
            return controller
        }
        return next
    }
    
    private func next(controller: UIViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
