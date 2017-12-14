//
//  MKPlaceAnnotation.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 11. 11..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import MapKit

class MKPlaceAnnotaion: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    let place: Place

    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D, place: Place) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.place = place

        super.init()
    }

    var subtitle: String? {
        return locationName
    }
}
