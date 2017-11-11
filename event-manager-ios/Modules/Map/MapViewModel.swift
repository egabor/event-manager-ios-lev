//
//  MapViewModel.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 11. 11..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import MapKit

class MapViewModel {

    // MARK: - let constants

    // MARK: - var variables
    var events = Variable([Event]())
    var places = Variable([Place]())
    var annotations = Variable([MKPlaceAnnotaion]())

    // MARK: - Lifecycle Methods

    init () {

        _ = RestClient.shared.events.asObservable().subscribe { [weak self] (event) in
            guard let eventList = event.element else { return }
            self?.events.value = eventList
            self?.annotations.value = eventList.map { $0.place }.uniqueElements.sorted { $0.order < $1.order }.map { place in
                let location = CLLocationCoordinate2DMake(place.location.latitude, place.location.longitude)
                let annotation = MKPlaceAnnotaion(title: place.name, locationName: place.type.rawValue, discipline: place.type.rawValue, coordinate: location)

                return annotation
            }
        }
    }

    deinit {
        // Don't forget to remove the observers here
    }

    // MARK: - Business Logic

    // MARK: - Helper Methods

}

// MARK: - Notification handlers can be placed here

extension MapViewModel {

}
