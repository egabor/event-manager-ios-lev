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
import Firebase

class ProfileViewModel {

    // MARK: - let constants

    // MARK: - var variables
    var userData = UserData() {
        didSet {
            name.value = userData.fullName
            email.value = userData.email ?? ""
            billingName.value = userData.billingName ?? ""
            billingAddress.value = userData.billingAddress ?? ""
            profileImageUrl.value = userData.profileImageUrl ?? ""
        }
    }
    
    var user: User? {
        didSet {
            name.value = user?.displayName ?? ""
            email.value = user?.email ?? ""
            profileImageUrl.value = user?.photoURL?.absoluteString ?? ""
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
        setUser(ReferenceManager.shared.user)
        
        /*self.isLoading.value = true
        Authenticator.shared.authenticate(with: .facebook) { [weak self] (user, error) in
            guard let strongSelf = self else { return }
            if let user = user {
                strongSelf.user = user
            }
            strongSelf.isLoading.value = false
        }*/
        
        /*self.isLoading.value = true
        RestClient.shared.getProfile { [weak self] (userData, error) in
            guard let strongSelf = self  else { return }
            if error != nil {
                print("Error: \(String(describing: error))")
            }
            if let userData = userData {
                strongSelf.userData = userData
         
            }
            strongSelf.isLoading.value = false
        }*/
    }

    deinit {
        // Don't forget to remove the observers here
    }

    // MARK: - Business Logic
    
    func setUser(_ user: User?) {
        self.user = user
    }

    // MARK: - Helper Methods

}

// MARK: - Notification handlers can be placed here

extension ProfileViewModel {

}
