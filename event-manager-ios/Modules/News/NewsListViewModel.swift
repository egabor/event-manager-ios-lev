//
//  NewsListViewModel.swift
//  event-manager-ios
//
//  Created by Gabor Nagy on 2017. 10. 26..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class NewsListViewModel {
    
    // MARK: - let constants
    
    // MARK: - var variables
    
    var sections = Variable([TableViewSection]())
    var dataSource = RxTableViewSectionedReloadDataSource<TableViewSection>()
    
    // MARK: Lifecycle Methods
    
    init () {
        RestClient.shared.getNews { [weak self] (events, error) in self?.mapEvents(events)
        }
    }
    
    // MARK: - Business Logic
    
    func mapEvents(_ events: [News]) {
        sections.value = [TableViewSection(items: events)]
    }
    
}
