import UIKit

class NavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        }
        return .default
    }
}

class NavigationBar: UINavigationBar {}
