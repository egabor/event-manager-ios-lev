//
//  News.swift
//  event-manager-ios
//
//  Created by Gabor Nagy on 2017. 10. 26..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation
import ObjectMapper

class News: BaseResponse {

    // MARK: - Model Properties
    var newsId: String! = ""
    var title: String! = ""
    var content: String! = ""
    var imageUrl: String! = ""
    var showOnDate: Date! = Date.init(timeIntervalSince1970: 0)

    required init?(map: Map) {
        super.init(map: map)
    }

    override init() {
        super.init()!
    }

    override func mapping(map: Map) {
        newsId <- map["id"]
        title <- map["title"]
        content <- map["content"]
        imageUrl <- map["imageUrl"]
        showOnDate <- (map["showOnDate"], DateTransform())
    }

    func description() -> String! {
        return "\(String(describing: self.toJSONString(prettyPrint: true)!))"
    }

}
