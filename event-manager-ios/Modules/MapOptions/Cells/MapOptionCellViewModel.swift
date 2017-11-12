//
//  MapOptionCellViewModel.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 11. 11..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class MapOptionCellViewModel {

    // MARK: - let constants

    // MARK: - var variables
    var title = Variable("")
    var isSelected = Variable(true)

    var model: MapOption? {
        didSet {
            guard let model = model else { return }
            title.value = model.placeType.rawValue
            isSelected.value = model.isVisible
        }
    }

    // MARK: - Lifecycle Methods

    init() {

    }

    init(with model: MapOption) {
        self.model = model
    }

    deinit {
        // Don't forget to remove the observers here
    }

    // MARK: - Business Logic

    // MARK: - Helper Methods

}

// MARK: - Notification handlers can be placed here

extension MapOptionCellViewModel {

}
