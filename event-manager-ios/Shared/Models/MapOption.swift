//
//  MapOption.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 11. 11..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation

class MapOption: Bindable {

    // MARK: - Model Properties
    var placeType: PlaceType
    var isVisible: Bool = true

    init (_ placeType: PlaceType, _ isVisible: Bool = true) {
        self.placeType = placeType
        self.isVisible = isVisible
    }
}
