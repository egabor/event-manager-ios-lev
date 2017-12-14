//
//  EventListViewController.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 07..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MBProgressHUD

class EventListViewController: UIViewController {

    // MARK: - let constants

    let disposeBag = DisposeBag()

    // The viewmodel must be let!
    // To prevent memory leaks change the model inside the viewmodel instead of changing the viewmodel object.
    let viewModel = EventListViewModel()

    // MARK: - var variables

    // MARK: - Interface Builder Outlets
    @IBOutlet weak var onlyGroupConstraint: NSLayoutConstraint!
    @IBOutlet weak var groupAndFilterConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var changeGroupButton: UIButton!
    @IBOutlet weak var changeFilterButton: UIButton!
    @IBOutlet weak var profileButton: UIBarButtonItem!

    // MARK: - ViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tabBarController?.performSegue(withIdentifier: "ShowLoading", sender: nil)
        //NotificationCenter.default.post(Notification(name: Constants.Notifications.ShowLoadingAnimationView))

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
        // Don't forget to remove the observers here
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

        viewModel.selectedGroup.asObservable().map { $0.name }.bind(to: changeGroupButton.rx.title()).disposed(by: disposeBag)
        viewModel.selectedFilter.asObservable().map { $0.name }.bind(to: changeFilterButton.rx.title()).disposed(by: disposeBag)
        /*viewModel.searchBarVisible.asObservable().subscribe { [weak self] (event) in
            guard let searchBarVisible = event.element else { return }
            if searchBarVisible {
                UIView.animate(withDuration: 0.3, animations: {
                    self?.tableView.contentOffset = CGPoint.init(x: 0, y: 0)
                })
            }
        }.disposed(by: disposeBag)*/

        tableView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)

        // MARK: - Cell Binding

        viewModel.dataSource.configureCell = { [weak self] dataSource, tableView, indexPath, item in
            return (self?.bindCell(tableView, item))!
        }

        // MARK: - Section Header and Footer Binding

        viewModel.dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header?.title
        }

        viewModel.dataSource.titleForFooterInSection = { dataSource, index in
            return dataSource.sectionModels[index].footer?.title
        }

        // MARK: - Section Binding

        viewModel.sections.asObservable()
            .bind(to: tableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)

        // MARK: - Selection Handling

        tableView.rx
            .modelSelected(Bindable.self)
            .subscribe(onNext: { [weak self] value in
                if let selectedIndexPath = self?.tableView.indexPathForSelectedRow {
                    self?.tableView.deselectRow(at: selectedIndexPath, animated: true)
                }
                self?.performSegue(withIdentifier: "ShowEventDetails", sender: value)
            })
            .disposed(by: disposeBag)

        /*
        tableView.rx
            .itemAccessoryButtonTapped
            .subscribe(onNext: { indexPath in
                print("Tapped Detail @ \(indexPath.section),\(indexPath.row)")
            })
            .disposed(by: disposeBag)
        */

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowEventDetails" {
            if let destination = segue.destination as? EventDetailsViewController {
                guard let model = sender as? Event else { return }
                destination.viewModel.model = model
            }
        } else if segue.identifier == "ShowFilterSelect" {
            if let destination = segue.destination as? EventFilterTableViewController {
                guard let model = sender as? ([Filter], Filter) else { return }
                guard let index = model.0.index(where: { (filter) -> Bool in
                    filter.name == model.1.name
                }) else { return }
                model.0.forEach { $0.selected = false }

                model.0[index].selected = true
                destination.viewModel.items.value = model.0

                destination.title = "SelectFilter.Title".localized
            }
        }
    }

    // MARK: - Helper Methods

    func bindCell(_ tableView: UITableView, _ item: Bindable) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(type(of: item))Cell")
        if let bindableCell = cell as? ReactiveBindable {
            bindableCell.bind(to: item)
        }
        return cell!
    }

    func showLoading() {
        NotificationCenter.default.post(Notification(name: Constants.Notifications.ShowLoadingAnimationView))
    }
}

// MARK: - TableView Delegate Methods

extension EventListViewController: UITableViewDelegate {

    /*
    // Uncomment in case of use custom section header

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let item = viewModel.dataSource[section].header else {
            return nil
        }
        return bindCell(tableView, item)
    }
    */

    /*
    // Uncomment in case of use custom section footer

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let item = viewModel.dataSource[section].footer else {
            return nil
        }
        return bindCell(tableView, item)
    }
    */

}

// MARK: - Interface Builder Actions

extension EventListViewController {
    @IBAction func toggleSearch(_ sender: UIBarButtonItem) {
        viewModel.searchBarVisible.value = !viewModel.searchBarVisible.value
        //self.searchBar.becomeFirstResponder()

    }

    @IBAction func changeGroup(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowFilterSelect", sender: (viewModel.groups, viewModel.selectedGroup.value))
    }

    @IBAction func changeFilter(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowFilterSelect", sender: (viewModel.selectedGroup.value.filters, viewModel.selectedFilter.value))
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

// MARK: - Notification handlers can be placed here

extension EventListViewController {

}
