//
//  EventFilter.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 20..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation

class EventFilter: Filter {
    
    // MARK: - Model Properties
    var name: String
    var identifier: String

    init (name: String, identifier: String) {
        self.name = name
        self.identifier = identifier
    }
}
