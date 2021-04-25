//
//  FrameworkAssets.swift
//  DetectaConnectSDK
//
//  Created by Konstantin on 4/24/21.
//

import UIKit

fileprivate class Framework {}
fileprivate var bundle: Bundle { Bundle(for: Framework.self) }

struct FrameworkAsset: _ExpressibleByImageLiteral {
    let image: UIImage

    init(imageLiteralResourceName name: String) {
        guard let image = UIImage(named: name, in: bundle, compatibleWith: nil) else {
            preconditionFailure("Image named \(name) was not found in bundle \(bundle)")
        }
        self.image = image
    }
}

extension UIColor {
    class func frameworkAsset(named name: String) -> UIColor {
        guard let color = UIColor(named: name, in: bundle, compatibleWith: nil) else {
            preconditionFailure("Color named \(name) was not found in bundle \(bundle)")
        }
        return color
    }
}

/// Examples:
/// let image = (#imageLiteral(resourceName: "detecta-medium") as FrameworkAsset).image
/// let color2 = UIColor.frameworkAsset(named: "AirBlue")
/// PlusButton.setImage(
///     (#imageLiteral(resourceName: "plus-medium") as FrameworkAsset).image.withTintColor(.frameworkAsset(named: "AirBlue")),
///     for: .normal
/// )
