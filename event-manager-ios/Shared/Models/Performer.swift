//
//  Performer.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 07..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation
import ObjectMapper

class Performer: BaseResponse {

    // MARK: - Model Properties
    var performerId: String! = ""
    var name: String! = ""
    var description: String? = ""
    var imageUrl: String! = ""

    required init?(map: Map) {
        super.init(map: map)
    }

    override init() {
        super.init()!
    }

    override func mapping(map: Map) {
        performerId <- map["id"]
        name <- map["name"]
        description <- map["description"]
        imageUrl <- map["imageUrl"]
    }
}
