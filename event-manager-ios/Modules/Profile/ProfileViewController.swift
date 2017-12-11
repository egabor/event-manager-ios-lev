//
//  ProfileViewController.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 12. 11..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ProfileViewController: UITableViewController {

    // MARK: - let constants

    let disposeBag = DisposeBag()

    // The viewmodel must be let!
    // To prevent memory leaks change the model inside the viewmodel instead of changing the viewmodel object.
    let viewModel = ProfileViewModel()

    // MARK: - var variables

    // MARK: - Interface Builder Outlets
    @IBOutlet weak var profileImageWrapperView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var billingNameLabel: UILabel!
    @IBOutlet weak var billingAddressLabel: UILabel!

    // MARK: - UIViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageWrapperView.layer.borderWidth = 2.0
        profileImageWrapperView.layer.borderColor = UIColor.black.cgColor
        // TODO: Do the viewmodel binding here
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageWrapperView.layer.cornerRadius = profileImageWrapperView.bounds.height / 2.0
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2.0
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

extension ProfileViewController {

}

// MARK: - Notification handlers can be placed here

extension ProfileViewController {

}
