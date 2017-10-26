//
//  EventGroup.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 20..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation

struct EventGroup {
    var name: String
    var option: EventGroupOption
    var filters: [EventFilter]
}
