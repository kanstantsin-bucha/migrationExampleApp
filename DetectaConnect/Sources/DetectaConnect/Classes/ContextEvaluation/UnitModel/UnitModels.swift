//
//  File.swift
//  
//
//  Created by Kanstantsin Bucha on 29/04/2022.
//

import Foundation

struct UnitModels: Decodable {
    var models: [UnitModel]
    enum CodingKeys: String, CodingKey {
        case models = "unit_models"
    }
}
