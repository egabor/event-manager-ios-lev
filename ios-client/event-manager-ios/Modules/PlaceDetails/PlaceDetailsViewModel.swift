//
//  PlaceDetailsViewModel.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 11. 11..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class PlaceDetailsViewModel {

    // MARK: - let constants
    let disposeBag = DisposeBag()

    // MARK: - var variables
    var place = Variable(Place())
    var bottomConstraintOffset = Variable(CGFloat(0.0))

    // Change the sections variable to update the TableView
    var sections = Variable([TableViewSection]())
    var dataSource = RxTableViewSectionedReloadDataSource<TableViewSection>()

    // MARK: - Lifecycle Methods

    init () {
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavoriteState(_:)), name: Constants.Notifications.EventFavoriteStateUpdated, object: nil)
        Observable.combineLatest(place.asObservable(), RestClient.shared.events.asObservable()) { [weak self] (place, events) in
            guard let strongSelf = self else { return }
            guard place.placeId.isEmpty == false else { return }
            let eventsForPlace = events.filter { $0.place.placeId == place.placeId }
            strongSelf.sections.value = [TableViewSection(items: eventsForPlace)]
        }.subscribe().disposed(by: disposeBag)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Business Logic

    // MARK: - Helper Methods

}

// MARK: - Notification handlers can be placed here

extension PlaceDetailsViewModel {
    @objc func updateFavoriteState(_ notification: Notification) {
        guard let event = notification.object as? Event else { return }
        guard let eventToUpdate = (RestClient.shared.events.value.filter { $0.eventId == event.eventId }.first) else { return }
        eventToUpdate.isFavorite = event.isFavorite
        self.place.value = self.place.value // triggering reload
    }
}
