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

    var model: EventDetailDescription? {
        didSet {
            guard let model = model else { return }
            description.value = model.description
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

extension EventDetailDescriptionCellViewModel {

}
