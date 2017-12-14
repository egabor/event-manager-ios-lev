//
//  EventFilterCellViewModel.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 26..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class EventFilterCellViewModel {

    // MARK: - let constants

    // MARK: - var variables
    var title = Variable("")
    var highlighted = Variable(false)

    var model: Filter? {
        didSet {
            guard let model = model else { return }
            title.value = model.name
            highlighted.value = model.selected
        }
    }

    // MARK: - Lifecycle Methods

    init() {

    }

    deinit {
        // Don't forget to remove the observers here
    }

    // MARK: - Business Logic

    // MARK: - Helper Methods

}

// MARK: - Notification handlers can be placed here

extension EventFilterCellViewModel {

}
