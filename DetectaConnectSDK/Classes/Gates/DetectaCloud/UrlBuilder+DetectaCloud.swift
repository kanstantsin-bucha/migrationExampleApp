//
//  UrlBuilder+DetectaCloud.swift
//  DetectaConnectSDK
//
//  Created by Kanstantsin Bucha on 3.04.21.
//

import Foundation

extension ApiUrlBuilder {
    public func addQuery(name: String, params: String? = nil, value: Any) -> Self {
        var query = name
        if let params = params {
            query += "[\(params)]"
        }
        return addItem(name: query, value: value)
    }
}
