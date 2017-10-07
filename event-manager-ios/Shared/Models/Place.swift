//
//  Place.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 07..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation
import ObjectMapper

class Place: BaseResponse {

    // MARK: - Model Properties
    var placeId: String! = ""
    var name: String! = ""
    var type: PlaceType! = .unknown
    var location: Location! = Location()
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override init() {
        super.init()!
    }
    
    override func mapping(map: Map) {
        placeId <- map["id"]
        name <- map["name"]
        type <- map["type"]
        location <- map["location"]
    }
}
