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
    let disposeBag = DisposeBag()

    // MARK: - var variables
    var events = Variable([Event]())
    var places = Variable([Place]())
    var placeTypesToFilter = Variable([PlaceType]())
    var annotations = Variable([MKPlaceAnnotaion]())
    var isLoading = Variable(false)

    // MARK: - Lifecycle Methods

    init () {
        NotificationCenter.default.addObserver(self, selector: #selector(updatePlaceTypesToFilter(_:)), name: Constants.Notifications.PlaceTypesUpdated, object: nil)

        _ = RestClient.shared.places.asObservable().subscribe { [weak self] (event) in
            guard let placeList = event.element else { return }
            self?.places.value = placeList.sorted { $0.order < $1.order }
        }

        Observable.combineLatest(places.asObservable(), placeTypesToFilter.asObservable()) { [weak self] (places, placeTypesToFilter) in
            self?.annotations.value = places.filter { place in !placeTypesToFilter.contains(place.type)}.map { place in
                let location = CLLocationCoordinate2DMake(place.location.latitude, place.location.longitude)
                let annotation = MKPlaceAnnotaion(title: place.name, locationName: place.type.rawValue.camelCaseToWords.firstUppercased, discipline: place.type.rawValue, coordinate: location, place: place)
                return annotation
            }
        }.subscribe().disposed(by: disposeBag)

    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Business Logic

    @objc func updatePlaceTypesToFilter(_ notification: Notification) {
        guard let typesToFilter = notification.object as? [PlaceType] else { return }
        self.placeTypesToFilter.value = typesToFilter
    }

    // MARK: - Helper Methods

}

// MARK: - Notification handlers can be placed here

extension MapViewModel {

}
