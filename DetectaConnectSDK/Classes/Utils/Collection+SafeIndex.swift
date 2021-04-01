//
//  Extensions.swift
//  Client iOS
//
//  Created by Kanstantsin Bucha on 8/11/18.
//  Copyright © 2019 Detecta Group. All rights reserved.
//

import Foundation

extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
