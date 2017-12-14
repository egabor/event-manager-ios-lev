//
//  BaseResponse.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 07..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import ObjectMapper

class BaseResponse: Mappable, Bindable {

    required init?(map: Map) {

    }

    init?() {

    }

    func mapping(map: Map) {

    }

    init(_ data: [String: Any]) {

    }
}
