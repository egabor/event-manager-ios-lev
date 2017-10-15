//
//  EventDetailDescriptionCellViewModel.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 15..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class EventDetailDescriptionCellViewModel {

    // MARK: - let constants

    // MARK: - var variables
    var description = Variable("")

    var model: Event? {
        didSet {
            guard let model = model else { return }
            description.value = model.performer.description!
        }
    }

    // MARK: - Lifecycle Methods

    init() {

    }

    init(with model: Event) {
        self.model = model
    }

    deinit {
        // Don't forget to remove the observers here
    }

    // MARK: - Business Logic

    // MARK: - Helper Methods

}

// MARK: - Notification handlers can be placed here

extension EventDetailDescriptionCellViewModel {

}
