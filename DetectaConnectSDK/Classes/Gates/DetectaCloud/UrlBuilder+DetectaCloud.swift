//
//  UrlBuilder+DetectaCloud.swift
//  DetectaConnectSDK
//
//  Created by Kanstantsin Bucha on 3.04.21.
//

import Foundation

extension ApiUrlBuilder {
    public func addQuery(name: String, field: String? = nil, value: Any) -> Self {
        var query = name
        if let field = field {
            query += "[\(field)]"
        }
        return addItem(name: query, value: value)
    }
}
