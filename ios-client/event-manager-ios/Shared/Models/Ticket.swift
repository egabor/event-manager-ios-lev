//
//  Ticket.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 12. 16..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation
import ObjectMapper

class Ticket: BaseResponse, Hashable, Equatable {
    var hashValue: Int { return ticketId.hashValue }

    static func == (lhs: Ticket, rhs: Ticket) -> Bool {
        return lhs.ticketId == rhs.ticketId
    }

    // MARK: - Model Properties
    var ticketId: String! = ""
    var eventId: String! = ""
    var userId: String! = ""
    var displayName: String! = ""
    var price: String! = ""

    required init?(map: Map) {
        super.init(map: map)
    }

    override init() {
        super.init()!
    }

    override func mapping(map: Map) {
        ticketId <- map["ticketId"]
        eventId <- map["eventId"]
        userId <- map["userId"]
        displayName <- map["displayName"]
        price <- map["price"]
    }

    init?(_ ticketId: String, _ displayName: String, _ price: String) {
        super.init()
        self.ticketId = ticketId
        self.displayName = displayName
        self.price = price
    }

    init?(_ ticketId: String, _ data: [String: Any]) {
        super.init()
        self.ticketId = ticketId
        self.displayName = data["displayName"] as? String ?? ""
        self.price = data["price"] as? String ?? ""
    }
}
