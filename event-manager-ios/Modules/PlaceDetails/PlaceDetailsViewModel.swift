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
        Observable.combineLatest(place.asObservable(), RestClient.shared.events.asObservable()) { [weak self] (place, events) in
            guard place.placeId.isEmpty == false else { return }
            let eventsForPlace = events.filter { $0.place.placeId == place.placeId }
            self?.sections.value = [TableViewSection(items: eventsForPlace)]
        }.subscribe().disposed(by: disposeBag)
    }

    deinit {
        // Don't forget to remove the observers here
    }

    // MARK: - Business Logic

    // MARK: - Helper Methods

}

// MARK: - Notification handlers can be placed here

extension PlaceDetailsViewModel {

}
