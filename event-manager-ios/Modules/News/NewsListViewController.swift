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

class NewsListViewController: UITableViewController {

    // MARK: - let constants

    let disposeBag = DisposeBag()
    let viewModel = NewsListViewModel()

    // MARK: - var variables

    // MARK: - Interface Builder Outlets

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

}
