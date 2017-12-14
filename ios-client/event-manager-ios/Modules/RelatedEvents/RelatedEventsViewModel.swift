//
//  RelatedEventsViewModel.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 12. 14..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class RelatedEventsViewModel {

    // MARK: - let constants
    let disposeBag = DisposeBag()

    // MARK: - var variables
    var event = Variable(Event())
    var items = Variable([Event]())

    // MARK: - Lifecycle Methods

    init () {
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavoriteState(_:)), name: Constants.Notifications.EventFavoriteStateUpdated, object: nil)
        Observable.combineLatest(event.asObservable(), RestClient.shared.events.asObservable()) { [weak self] (event, events) in
            guard let strongSelf = self else { return }
            guard event.eventId.isEmpty == false else { return }
            let relatedEvents = events.filter { ($0.relatedEvents?.contains(event.eventId) ?? false) }
            strongSelf.items.value = relatedEvents
            }.subscribe().disposed(by: disposeBag)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Business Logic

    // MARK: - Helper Methods

}

// MARK: - Notification handlers can be placed here

extension RelatedEventsViewModel {
    @objc func updateFavoriteState(_ notification: Notification) {
        guard let event = notification.object as? Event else { return }
        guard let eventToUpdate = (RestClient.shared.events.value.filter { $0.eventId == event.eventId }.first) else { return }
        eventToUpdate.isFavorite = event.isFavorite
        self.event.value = self.event.value // triggering reload
    }
}
