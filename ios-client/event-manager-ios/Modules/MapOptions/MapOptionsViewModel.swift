//
//  MapOptionsViewModel.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 11. 11..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class MapOptionsViewModel {

    // MARK: - let constants
    let disposeBag = DisposeBag()
    // MARK: - var variables

    // Change the sections variable to update the TableView
    var sections = Variable([TableViewSection]())
    var dataSource = RxTableViewSectionedReloadDataSource<TableViewSection>()

    var places = Variable([Place]())
    var placeTypesToFilter = Variable([PlaceType]())

    // MARK: - Lifecycle Methods

    init () {
        Observable.combineLatest(places.asObservable(), placeTypesToFilter.asObservable()) { [weak self] (places, placeTypesToFilter) in
            self?.sections.value = [TableViewSection(header: MapOptionHeader(with: "MapOptions.Header.HideShowPlacesByType.Title".localized), items: places.map { $0.type }.uniqueElements.map { MapOption($0, !placeTypesToFilter.contains($0)) })]
        }.subscribe().disposed(by: disposeBag)
    }

    deinit {
        // Don't forget to remove the observers here
    }

    // MARK: - Business Logic

    // MARK: - Helper Methods

}

// MARK: - Notification handlers can be placed here

extension MapOptionsViewModel {

}
