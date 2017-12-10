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
                   EventGroup(name: "Days", option: .days, filters: []),
                   EventGroup(name: "Months", option: .months, filters: []),
                   EventGroup(name: "Favorites", option: .favorites, filters: [])
                   //EventGroup(name: "Live", option: .live, filters: [])
    ]

    var selectedGroup = Variable(EventGroup(name: "A-Z", option: .alphabetical, filters: []))
    var selectedFilter = Variable(EventFilter(name: "Events.Filter.All.Text".localized, identifier: "Events.Filter.All.Text"))

    // MARK: - Lifecycle Methods

    init () {
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavoriteState(_:)), name: Constants.Notifications.EventFavoriteStateUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateFilter(_:)), name: Constants.Notifications.EventFilterUpdated, object: nil)

        _ = RestClient.shared.events.asObservable().subscribe { [weak self] (event) in
            guard let eventList = event.element else { return }
            self?.events.value = eventList
            self?.mapEvents(eventList, self?.selectedGroup.value, self?.selectedFilter.value)

            //NotificationCenter.default.post(name: Constants.Notifications.HideLoadingAnimationView, object: nil)
        }

        events.asObservable().subscribe { [weak self] (event) in
            guard let eventsToFilter = event.element else { return }

            if (self?.groups.count ?? 0) > 0 {
                for i in 0 ..< self!.groups.count {
                    let group = self!.groups[i]
                    group.filters.removeAll()
                    switch group.option {
                    case .places, .live:
                        self!.groups[i].filters = eventsToFilter.map { $0.place }.uniqueElements.sorted { $0.order < $1.order }.map { EventFilter(name: $0.name, identifier: $0.placeId) }
                    case .days:
                        self!.groups[i].filters = eventsToFilter.map { $0.showOnDate }.uniqueElements.sorted { $0 < $1 }.map { EventFilter(name: $0.longDate()!, identifier: $0.toString()!) }
                    case .favorites:
                        self!.groups[i].filters = eventsToFilter.map { $0.showOnDate }.uniqueElements.sorted { $0 < $1 }.map { EventFilter(name: $0.longDate()!, identifier: $0.toString()!) }
                    case .months:
                        self!.groups[i].filters = eventsToFilter.map { $0.showOnDate.toString(format: "yyyy. MMMM")! }.uniqueElements.sorted { $0 < $1 }.map { EventFilter(name: $0, identifier: $0) }
                    default:
                        break
                    }
                    self!.groups[i].filters.insert(EventFilter(name: "Events.Filter.All.Text".localized, identifier: "Events.Filter.All.Text"), at: 0)
                }
            }
        }.disposed(by: disposeBag)
        if groups.count > 0 && groups.first!.filters.count > 0 {
            selectedGroup.value = groups.first!
            selectedFilter.value = selectedGroup.value.filters.first!
        }

        Observable.combineLatest(events.asObservable(), selectedGroup.asObservable(), selectedFilter.asObservable()) { [weak self] (eventsList, selectedGroup, selectedFilter) in
            self?.mapEvents(eventsList, selectedGroup, selectedFilter)
        }.subscribe().disposed(by: disposeBag)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Business Logic

    func mapEvents(_ eventsList: [Event], _ group: EventGroup?, _ filter: EventFilter?) {
        guard let group = group else { print("ERROR: No group"); return }
        guard let filter = filter else { print("ERROR: No filter"); return }
        eventsList.forEach { $0.displayPriority = group.option }
        var filteredEvents = [Event]()

        if filter.identifier == "Events.Filter.All.Text" {
            filteredEvents = eventsList
        } else {
            filteredEvents =  eventsList.filter { $0.place.name == filter.name }
        }

        // Convert Events to TableView Sections
        // 1. GROUP (first charecter, place, date)
        // 2. CREATE SECTIONS
        // 3. SORT (name | date)
        var data = [TableViewSection]()
        switch group.option {
        case .alphabetical:
            filteredEvents.group { $0.performer.name.uppercased().first! }.forEach { (key, element) in
                data.append(TableViewSection(header: EventHeader(with: "\(key)"), items: element))
            }
            data = data.sorted { ($0.header?.title ?? "") < ($1.header?.title ?? "") }
        case .places, .live:
            filteredEvents.group { $0.place.name }.forEach { (key, element) in
                data.append(TableViewSection(header: EventHeader(with: key), items: element))
            }
        case .days:
            filteredEvents.group { $0.showOnDate.longDate()! }.forEach { (key, element) in
                data.append(TableViewSection(header: EventHeader(with: key), items: element))
            }
        default:
            break
        }

        sections.value = data
    }

    // MARK: - Helper Methods

}

// MARK: - Notification handlers can be placed here

extension EventListViewModel {
    @objc func updateFavoriteState(_ notification: Notification) {
        guard let event = notification.object as? Event else { return }
        guard let eventToUpdate = (RestClient.shared.events.value.filter { $0.eventId == event.eventId }.first) else { return }
        eventToUpdate.isFavorite = event.isFavorite
        self.mapEvents(events.value, selectedGroup.value, selectedFilter.value)
    }

    @objc func updateFilter(_ notification: Notification) {
        if let newGroup = notification.object as? EventGroup {
            selectedGroup.value = newGroup
        } else if let newFilter = notification.object as? EventFilter {
            selectedFilter.value = newFilter
        }
    }
}
