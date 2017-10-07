//
//  EventListViewModel.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 07..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class EventListViewModel {

    // MARK: - let constants

    // MARK: - var variables

    // Change the sections variable to update the TableView
    var sections = Variable([TableViewSection]())
    var dataSource = RxTableViewSectionedReloadDataSource<TableViewSection>()

    // MARK: - Lifecycle Methods

    init () {
        RestClient.shared.getEvents { [weak self] (events, error) in
            self?.mapEvents(events)
        }
    }

    deinit {
        // Don't forget to remove the observers here
    }

    // MARK: - Business Logic
    
    func mapEvents(_ events: [Event]) {
        sections.value = [TableViewSection(items: events)]
        /*events.group { $0.performer.name }.forEach { (key,element) in
            print("\(key): \(element)")
        }*/
        
    }

    // MARK: - Helper Methods

}

// MARK: - Notification handlers can be placed here

extension EventListViewModel {

}
