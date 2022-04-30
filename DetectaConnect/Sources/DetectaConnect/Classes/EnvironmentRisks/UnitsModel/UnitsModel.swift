//
//  UnitsModel.swift
//  
//
//  Created by Kanstantsin Bucha on 29/04/2022.
//

import Foundation

struct UnitsModel: Decodable {
    var models: [UnitModel]
    enum CodingKeys: String, CodingKey {
        case models = "unit_models"
    }
}
