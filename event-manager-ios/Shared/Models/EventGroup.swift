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
    var option: EventGroupOption
    var filters: [EventFilter]
    
    init (name: String, option: EventGroupOption, filters: [EventFilter]) {
        self.option = option
        self.filters = filters
        super.init(name: name)
    }
}
