//
//  EventGroup.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 20..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation

class EventGroup: Filter {
    
    // MARK: - Model Properties
    var name: String
    var option: EventGroupOption
    var filters: [EventFilter]
    
    init (name: String, option: EventGroupOption, filters: [EventFilter]) {
        self.name = name
        self.option = option
        self.filters = filters
    }
}
