//
//  Event.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 07..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation
import ObjectMapper

class Event: BaseResponse, Hashable, Equatable {
    var hashValue: Int { return eventId.hashValue }

    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.eventId == rhs.eventId
    }

    // MARK: - Model Properties
    var eventId: String! = ""
    var performer: Performer! = Performer()
    var place: Place! = Place()
    var type: EventType! = .unknown
    var relatedEvents: [String]? = []
    var showOnDate: Date! = Date.init(timeIntervalSince1970: 0)
    var startDate: Date! = Date.init(timeIntervalSince1970: 0)
    var performingMinutes: Int = 0
    var isFavorite: Bool = false
    var facebookEventUrl: String?
    var imageUrl: String?
    var availableTickets: [Ticket]?
    
    var displayPriority: EventGroupOption?

    required init?(map: Map) {
        super.init(map: map)
    }

    override init() {
        super.init()!
    }

    override func mapping(map: Map) {
        eventId <- map["id"]
        performer <- map["performer"]
        place <- map["place"]
        type <- map["type"]
        relatedEvents <- map["relatedEvents"]
        showOnDate <- (map["showOnDate"], DateTransform())
        startDate <- (map["startDate"], DateTransform())
        performingMinutes <- map["performingMinutes"]
        isFavorite <- map["isFavorite"]
        facebookEventUrl <- map["facebookEventUrl"]
        imageUrl <- map["imageUrl"]
        availableTickets <- map["availableTickets"]
    }

    func description() -> String! {
        return "\(String(describing: self.toJSONString(prettyPrint: true)!))"
    }
}
