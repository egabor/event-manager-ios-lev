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
    let disposeBag = DisposeBag()
    
    // MARK: - var variables
    var searchBarVisible = Variable(false)

    // Change the sections variable to update the TableView
    var sections = Variable([TableViewSection]())
    var dataSource = RxTableViewSectionedReloadDataSource<TableViewSection>()
    var events = Variable([Event]())
    
    var groups = [ EventGroup(name: "A-Z", option: .alphabetical, filters: []),
                   EventGroup(name: "Places", option: .places, filters: []),
                   EventGroup(name: "Dates", option: .dates, filters: []),
                   EventGroup(name: "Favorites", option: .favorites, filters: []),
                   EventGroup(name: "Live", option: .live, filters: [])]

    // MARK: - Lifecycle Methods

    init () {
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavoriteState(_:)), name: Constants.Notifications.EventFavoriteStateUpdated, object: nil)
        _ = RestClient.shared.events.asObservable().subscribe { [weak self] (event) in
            guard let eventList = event.element else { return }
            self?.events.value = eventList
            self?.mapEvents(eventList)
            
            //NotificationCenter.default.post(name: Constants.Notifications.HideLoadingAnimationView, object: nil)
        }
        /*RestClient.shared.getEvents { [weak self] (events, error) in
            self?.mapEvents(events)
        }*/
        events.asObservable().subscribe { [weak self] (event) in
            guard let eventsToFilter = event.element else { return }
            
            if (self?.groups.count ?? 0) > 0 {
                for i in 0 ..< self!.groups.count {
                    let group = self!.groups[i]
                    switch group.option {
                    case .alphabetical:
                        break
                    case .places, .live:
                        self!.groups[i].filters = eventsToFilter.map { $0.place }.uniqueElements.sorted { $0.order < $1.order }.map { EventFilter(name: $0.name, identifier: $0.placeId) }
                        self!.groups[i].filters.insert(EventFilter(name: "Events.Filter.All.Text".localized, identifier: "Events.Filter.All.Text"), at: 0)
                    case .dates:
                        break
                    case .favorites:
                        break
                    }
                }
            }
        }.disposed(by: disposeBag)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Business Logic

    func mapEvents(_ events: [Event]) {
        sections.value = [TableViewSection(items: events)]
        /*events.group { $0.performer.name }.forEach { (key,element) in
            print("\(key): \(element)")
        }*/

    }
    
    func collectGroups() {
        
    }
    
    func collectFilters() {
        
    }

    // MARK: - Helper Methods

}

// MARK: - Notification handlers can be placed here

extension EventListViewModel {
    @objc func updateFavoriteState(_ notification: Notification) {
        guard let event = notification.object as? Event else { return }
        guard let eventToUpdate = (RestClient.shared.events.value.filter { $0.eventId == event.eventId }.first) else { return }
        eventToUpdate.isFavorite = event.isFavorite
        self.mapEvents(RestClient.shared.events.value)
    }
}
