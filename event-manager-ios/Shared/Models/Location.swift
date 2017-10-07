//
//  Location.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 07..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation
import ObjectMapper

class Location: BaseResponse {

    // MARK: - Model Properties
    var longitude: Double! = 0.0
    var latitude: Double! = 0.0

    required init?(map: Map) {
        super.init(map: map)
    }

    override init() {
        super.init()!
    }

    override func mapping(map: Map) {
        longitude <- map["longitude"]
        latitude <- map["latitude"]
    }
}
