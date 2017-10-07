//
//  Place.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 07..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation

class Place: Bindable {

    // MARK: - Model Properties
    var performerId: String! = ""
    var name: String! = ""
    var type: PlaceType! = .unknown
    var location: Location! = Location()
    
    init () {

    }
}
