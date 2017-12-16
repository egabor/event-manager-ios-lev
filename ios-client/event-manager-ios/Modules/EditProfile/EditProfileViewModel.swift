//
//  EditProfileViewModel.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 12. 16..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class EditProfileViewModel {

    // MARK: - let constants
    let disposeBag = DisposeBag()

    // MARK: - var variables
    var userData = Variable(UserData()) {
        didSet {
            editedName.value = userData.value.billingName ?? ""
            editedZipCode.value = userData.value.billingZipCode ?? ""
            editedCity.value = userData.value.billingCity ?? ""
            editedAddress.value = userData.value.billingAddress ?? ""
        }
    }

    var editedName = Variable("")
    var editedZipCode = Variable("")
    var editedCity = Variable("")
    var editedAddress = Variable("")
    var isLoading = Variable(false)

    var editedUserData = UserData()

    // MARK: - Lifecycle Methods

    init () {
        Observable.combineLatest(editedName.asObservable(), editedZipCode.asObservable(), editedCity.asObservable(), editedAddress.asObservable()) { [weak self] (editedName, editedZipCode, editedCity, editedAddress) in
            guard let strongSelf = self else { return }
            strongSelf.editedUserData.userId = strongSelf.userData.value.userId
            strongSelf.editedUserData.authToken = strongSelf.userData.value.authToken
            strongSelf.editedUserData.billingName = editedName
            strongSelf.editedUserData.billingZipCode = editedZipCode
            strongSelf.editedUserData.billingCity = editedCity
            strongSelf.editedUserData.billingAddress = editedAddress
            }.subscribe().disposed(by: disposeBag)
    }

    deinit {
        // Don't forget to remove the observers here
    }

    // MARK: - Business Logic

    // MARK: - Helper Methods

}

// MARK: - Notification handlers can be placed here

extension EditProfileViewModel {

}
