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

    var model: Filter? {
        didSet {
            // Prepare the values
        }
    }

    // MARK: - Lifecycle Methods

    init() {

    }

    init(with model: Filter) {
        self.model = model
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
