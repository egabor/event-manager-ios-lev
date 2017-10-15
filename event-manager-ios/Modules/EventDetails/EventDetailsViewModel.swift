//
//  EventDetailsViewModel.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 15..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class EventDetailsViewModel {

    // MARK: - let constants

    // MARK: - var variables
    var model: Event? {
        didSet {
            guard let model = model else { return }
            imageUrl.value = model.performer.imageUrl
            name.value = model.performer.name
        }
    }
    
    var imageUrl = Variable("")
    var name = Variable("")

    // Change the sections variable to update the TableView
    var sections = Variable([TableViewSection]())
    var dataSource = RxTableViewSectionedReloadDataSource<TableViewSection>()

    // MARK: - Lifecycle Methods

    init () {

    }

    deinit {
        // Don't forget to remove the observers here
    }

    // MARK: - Business Logic

    // MARK: - Helper Methods

}

// MARK: - Notification handlers can be placed here

extension EventDetailsViewModel {

}
