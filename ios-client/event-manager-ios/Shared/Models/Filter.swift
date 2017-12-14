//
//  Filter.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 26..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation

class Filter: Bindable {

    // MARK: - Model Properties
    var name: String
    var selected = false
    
    init (name: String) {
        self.name = name
    }
}
