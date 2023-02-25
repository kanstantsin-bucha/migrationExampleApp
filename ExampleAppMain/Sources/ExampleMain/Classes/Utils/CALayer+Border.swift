import UIKit

extension CALayer {
    @objc var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.cgColor
        }
    
        get {
            return UIColor(cgColor: self.borderColor!)
        }
    }
}
