//
//  ApiUrlBuilder.swift
//  DetectaConnect
//
//  Created by Kanstantsin Bucha on 31.03.21.
//  Copyright © 2021 Detecta Group. All rights reserved.
//

import Foundation

public class ApiUrlBuilder {
    private var components: URLComponents
    
    public init(_ base: String) {
        guard let components = URLComponents(string: base) else {
            preconditionFailure("Base url should be a valid URL string")
        }
        self.components = components
    }
    
    public func addPath(path: String) -> Self {
        components.path += "/" + path
        return self
    }
    
    public func addItem(name: String, value: Any?) -> Self {
        let item: URLQueryItem
        if let value = value {
            item = URLQueryItem(name: name, value: String(describing: value))
        } else {
            item = URLQueryItem(name: name, value: nil)
        }
        var items = components.queryItems ?? []
        items.append(item)
        components.queryItems = items
        return self
    }
    
    public func url() -> URL {
        guard let url = components.url?.absoluteURL else {
            preconditionFailure("Failed to create an url from components")
        }
        return url
    }
}


