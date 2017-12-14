//
//  EventDetailDescription.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 15..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation
import ObjectMapper

class EventDetailDescription: Bindable {

    // MARK: - Model Properties
    var description = ""

    init(_ description: String) {
        self.description = description
    }
}
