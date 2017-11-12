//
//  Place.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 07..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation
import ObjectMapper

class Place: BaseResponse, Hashable, Equatable {
    var hashValue: Int { get { return placeId.hashValue } }

    static func == (lhs: Place, rhs: Place) -> Bool {
         return lhs.placeId == rhs.placeId
    }

    // MARK: - Model Properties
    var placeId: String! = ""
    var name: String! = ""
    var type: PlaceType! = .unknown
    var location: Location! = Location()
    var order: Int! = 0
    var hasDetails: Bool = true // Computed property, no mapping needed

    required init?(map: Map) {
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
        order <- map["order"]
    }
}
