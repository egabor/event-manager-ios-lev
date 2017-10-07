//
//  EventCellViewModel.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 07..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class EventCellViewModel {

    // MARK: - let constants

    // MARK: - var variables
    var name = Variable("")

    var model: Event? {
        didSet {
            guard let model = model else { return }
            name.value = model.performer.name
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

extension EventCellViewModel {

}
