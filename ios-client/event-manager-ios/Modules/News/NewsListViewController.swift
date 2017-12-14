//
//  NewsListViewController.swift
//  event-manager-ios
//
//  Created by Gabor Nagy on 2017. 10. 26..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MBProgressHUD

class NewsListViewController: UITableViewController {

    // MARK: - let constants

    let disposeBag = DisposeBag()
    let viewModel = NewsListViewModel()

    // MARK: - var variables

    // MARK: - Interface Builder Outlets
    @IBOutlet weak var profileButton: UIBarButtonItem!

    // MARK: - ViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = nil

        // Uncomment if the cells are self-sizing
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60

        /*
         // Uncomment in case of use custom section headers or footers
         tableView.sectionHeaderHeight = UITableViewAutomaticDimension
         tableView.estimatedSectionHeaderHeight = 100
         tableView.sectionFooterHeight = UITableViewAutomaticDimension
         tableView.estimatedSectionFooterHeight = 1
         */

        setUpBindings()
    }

    deinit {

    }

    func setUpBindings() {
        
        viewModel.isLoading.asObservable().throttle(1.0, latest: true, scheduler: MainScheduler.instance).subscribe { [weak self] (event) in
            guard let strongSelf = self else { return }
            guard let isLoading = event.element else { return }
            if isLoading {
                MBProgressHUD.showAdded(to: strongSelf.view, animated: true)
            } else {
                MBProgressHUD.hide(for: strongSelf.view, animated: true)
            }
            }.disposed(by: disposeBag)
        viewModel.isLoading.asObservable().map { !$0 }.throttle(1.0, latest: true, scheduler: MainScheduler.instance).bind(to: profileButton.rx.isEnabled).disposed(by: disposeBag)


        tableView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)

        // MARK: - Cell Binding

        viewModel.dataSource.configureCell = { [weak self] dataSource, tableView, indexPath, item in
            return (self?.bindCell(tableView, item))!
        }

        // MARK: - Section Binding

        viewModel.sections.asObservable().bind(to: tableView.rx.items(dataSource: viewModel.dataSource)).disposed(by: disposeBag)
    }

    // MARK: - Helper Methods

    func bindCell(_ tableView: UITableView, _ item: Bindable) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(type(of: item))Cell")
        if let bindableCell = cell as? ReactiveBindable {
            bindableCell.bind(to: item)
        }
        return cell!
    }

    @IBAction func showProfile(_ sender: UIBarButtonItem?) {
        viewModel.isLoading.value = true
        Authenticator.shared.authenticate(with: .facebook) { [weak self] (user, error) in
            guard let strongSelf = self else { return }
            strongSelf.viewModel.isLoading.value = false
            if error != nil {
                let alert = UIAlertController(title: "Login.Error.Title".localized, message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Login.Error.Ok.Button".localized, style: UIAlertActionStyle.default, handler: nil))
                strongSelf.present(alert, animated: true, completion: nil)
            }
            if let user = user {
                strongSelf.performSegue(withIdentifier: "ShowProfile", sender: nil)
            }
        }
    }
}
