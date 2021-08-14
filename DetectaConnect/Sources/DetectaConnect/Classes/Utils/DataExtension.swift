//
//  DataExtension.swift
//  client
//
//  Created by bucha on 11/19/20.
//  Copyright © 2020 Detecta Group. All rights reserved.
//

import Foundation

extension Data {
    
    var humanReadable: String {
        return self.compactMap({ String(format: "%02x ", $0) }).joined(separator: "-")
    }
    
    // MARK: - Data operations

    init<T>(from value: T) {
        self = Swift.withUnsafeBytes(of: value) { Data($0) }
    }
    
    func to<T>(type: T.Type) -> T? where T: ExpressibleByIntegerLiteral {
        var value: T = 0
        guard count >= MemoryLayout.size(ofValue: value) else { return nil }
        _ = Swift.withUnsafeMutableBytes(of: &value, { copyBytes(to: $0)} )
        return value
    }

}
