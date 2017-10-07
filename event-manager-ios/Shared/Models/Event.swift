//
//  Event.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 07..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation

class Event: Bindable {

    // MARK: - Model Properties
    var eventId: String! = ""
    var performer: Performer! = Performer()
    var place: Place! = Place()
    var type: EventType! = .unknown
    var relatedEvents: [Event]? = []
    var showOnDate: Date! = Date.init(timeIntervalSince1970: 0)
    var startDate: Date! = Date.init(timeIntervalSince1970: 0)
    var performingMinutes: Int = 0

    init () {

    }
    
    func description() -> String! {
        return "\"event\": {\n\t\"eventId\": \(self.eventId),\n\t\"type\": \(self.type!)\n\t\"performingMinutes\": \(self.performingMinutes)\n}"
    }
}
