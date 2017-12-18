//
//  TicketCellViewModel.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 12. 18..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class TicketCellViewModel {

    // MARK: - let constants

    // MARK: - var variables

    var model: Ticket? {
        didSet {
            guard let model = model else { return }
            guard let displayName = model.displayName else { return }
            guard let price = model.price else { return }
            title.value = "\(displayName) | \(price)"
        }
    }
    var title = Variable("")

    // MARK: - Lifecycle Methods

    init() {

    }

    init(with model: Ticket) {
        self.model = model
    }

    deinit {
        // Don't forget to remove the observers here
    }

    // MARK: - Business Logic

    // MARK: - Helper Methods

}

// MARK: - Notification handlers can be placed here

extension TicketCellViewModel {

}
