//
//  EditProfileViewController.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 12. 16..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MBProgressHUD

class EditProfileViewController: UITableViewController {

    // MARK: - let constants

    let disposeBag = DisposeBag()

    // The viewmodel must be let!
    // To prevent memory leaks change the model inside the viewmodel instead of changing the viewmodel object.
    let viewModel = EditProfileViewModel()

    // MARK: - var variables

    // MARK: - Interface Builder Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    // MARK: - UIViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.userData.asObservable().map { $0.billingName }.bind(to: nameTextField.rx.text).disposed(by: disposeBag)
        viewModel.userData.asObservable().map { $0.billingZipCode }.bind(to: zipCodeTextField.rx.text).disposed(by: disposeBag)
        viewModel.userData.asObservable().map { $0.billingCity }.bind(to: cityTextField.rx.text).disposed(by: disposeBag)
        viewModel.userData.asObservable().map { $0.billingAddress }.bind(to: addressTextField.rx.text).disposed(by: disposeBag)

        nameTextField.rx.text.orEmpty.bind(to: viewModel.editedName).disposed(by: disposeBag)
        zipCodeTextField.rx.text.orEmpty.bind(to: viewModel.editedZipCode).disposed(by: disposeBag)
        cityTextField.rx.text.orEmpty.bind(to: viewModel.editedCity).disposed(by: disposeBag)
        addressTextField.rx.text.orEmpty.bind(to: viewModel.editedAddress).disposed(by: disposeBag)
        
        viewModel.isLoading.asObservable().map { !$0 }.throttle(1.0, latest: true, scheduler: MainScheduler.instance).bind(to: saveButton.rx.isEnabled).disposed(by: disposeBag)
        viewModel.isLoading.asObservable().throttle(1.0, latest: true, scheduler: MainScheduler.instance).subscribe { [weak self] (event) in
            guard let strongSelf = self else { return }
            guard let isLoading = event.element else { return }
            if isLoading {
                MBProgressHUD.showAdded(to: strongSelf.view, animated: true)
            } else {
                MBProgressHUD.hide(for: strongSelf.view, animated: true)
            }
            }.disposed(by: disposeBag)

    }

    deinit {
        // Don't forget to remove the observers here
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Helper Methods

}

// MARK: - Interface Builder Actions

extension EditProfileViewController {
    @IBAction func saveProfile(_ sender: UIBarButtonItem) {
        viewModel.isLoading.value = true
        RestClient.shared.editProfile(viewModel.editedUserData) { [weak self] (user, error) in
            guard let strongSelf = self else { return }
            if user != nil {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateUser"), object: user)
                strongSelf.navigationController?.popViewController(animated: true)
            }
            strongSelf.viewModel.isLoading.value = false
        }
    }
}

// MARK: - Notification handlers can be placed here

extension EditProfileViewController {

}
