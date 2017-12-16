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
import SDWebImage
import SnapKit
import MBProgressHUD

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
    @IBOutlet weak var billingZipCodeLabel: UILabel!
    @IBOutlet weak var billingCityLabel: UILabel!
    @IBOutlet weak var billingAddressLabel: UILabel!

    // MARK: - UIViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageWrapperView.layer.borderWidth = 2.0
        profileImageWrapperView.layer.borderColor = UIColor.black.cgColor

        viewModel.name.asObservable().bind(to: nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.email.asObservable().map { "Profile.Email".localized + $0 }.bind(to: emailLabel.rx.text).disposed(by: disposeBag)
        viewModel.billingName.asObservable().subscribe { [weak self] (event) in
            guard let strongSelf = self else { return }
            guard let billingName = event.element else { return }
            strongSelf.billingNameLabel.text = billingName
            strongSelf.tableView.reloadData()
            }.disposed(by: disposeBag)
        
        viewModel.billingZipCode.asObservable().subscribe { [weak self] (event) in
            guard let strongSelf = self else { return }
            guard let billingZipCode = event.element else { return }
            strongSelf.billingZipCodeLabel.text = billingZipCode
            strongSelf.tableView.reloadData()
            }.disposed(by: disposeBag)
        
        viewModel.billingCity.asObservable().subscribe { [weak self] (event) in
                guard let strongSelf = self else { return }
                guard let billingCity = event.element else { return }
                strongSelf.billingCityLabel.text = billingCity
                strongSelf.tableView.reloadData()
                }.disposed(by: disposeBag)

        viewModel.billingAddress.asObservable().subscribe { [weak self] (event) in
            guard let strongSelf = self else { return }
            guard let billingAddress = event.element else { return }
            strongSelf.billingAddressLabel.text = billingAddress
            strongSelf.tableView.reloadData()
            }.disposed(by: disposeBag)

        viewModel.profileImageUrl.asObservable().subscribe { [weak self] (event) in
            guard let strongSelf = self else { return }
            guard let imageUrl = event.element else { return }
            strongSelf.profileImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder"))
            }.disposed(by: disposeBag)
        
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
    
    @IBAction func showEditProfile(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ShowEditProfile", sender: nil)
    }

}

// MARK: - Notification handlers can be placed here

extension ProfileViewController {

}
