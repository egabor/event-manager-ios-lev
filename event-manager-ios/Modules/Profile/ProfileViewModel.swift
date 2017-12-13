//
//  ProfileViewModel.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 12. 11..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ProfileViewModel {

    // MARK: - let constants

    // MARK: - var variables
    var user = User() {
        didSet {
            name.value = user.fullName
            email.value = user.email ?? ""
            billingName.value = user.billingName ?? ""
            billingAddress.value = user.billingAddress ?? ""
            profileImageUrl.value = user.profileImageUrl ?? ""
        }
    }
    
    var name = Variable("")
    var email = Variable("")
    var billingName = Variable("")
    var billingAddress = Variable("")
    var profileImageUrl = Variable("")
    var isLoading = Variable(false)
    

    // MARK: - Lifecycle Methods

    init () {
        self.isLoading.value = true
        RestClient.shared.getProfile { [weak self] (user, error) in
            guard let strongSelf = self  else { return }
            if error != nil {
                print("Error: \(String(describing: error))")
            }
            if let user = user {
                strongSelf.user = user
                strongSelf.isLoading.value = false
            }
        }
    }

    deinit {
        // Don't forget to remove the observers here
    }

    // MARK: - Business Logic

    // MARK: - Helper Methods

}

// MARK: - Notification handlers can be placed here

extension ProfileViewModel {

}
