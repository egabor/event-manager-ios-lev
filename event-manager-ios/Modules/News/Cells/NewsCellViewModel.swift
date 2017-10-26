//
//  NewsCellViewModel.swift
//  event-manager-ios
//
//  Created by Gabor Nagy on 2017. 10. 26..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class NewsCellViewModel {
    
    // MARK: - let constants
    
    // MARK: - var variables
    var imageUrl = Variable("")
    var title = Variable("")
    var showOnDate = Variable("")
    
    var model: News? {
        didSet {
            guard let model = model else { return }
            imageUrl.value = model.imageUrl
            title.value = model.title
            showOnDate.value = model.showOnDate.toString(format: "yyyy.MM.dd. HH:mm")!
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
