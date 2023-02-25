import Foundation
import UIKit

class ViewFactory {
    static var viewTypes: UIStoryboard {
        let result = UIStoryboard(name: "Views", bundle: ExampleApp.assetsBundle)
        return result
    }
    
    //MARK: - logic -
    
    static func loadView<T: UIViewController>(id: String) -> T {
        let view = viewTypes.instantiateViewController(withIdentifier: id) as! T
        return view
    }
    
    static func loadView(nibName: String, owner: UIView) -> UIView {
        let nib = UINib(nibName: nibName, bundle: ExampleApp.assetsBundle)
        guard let view = nib.instantiate(withOwner: owner, options: nil).first as? UIView else {
            preconditionFailure("Failed to load view: \(nibName), owner: \(owner)")
        }
        return view
    }
}
