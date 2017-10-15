//
//  EventDetailsViewController.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 15..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SDWebImage

class EventDetailsViewController: UIViewController {

    // MARK: - let constants

    let disposeBag = DisposeBag()

    // The viewmodel must be let!
    // To prevent memory leaks change the model inside the viewmodel instead of changing the viewmodel object.
    let viewModel = EventDetailsViewModel()

    // MARK: - var variables

    // MARK: - Interface Builder Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var performerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    // MARK: - ViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = nil

        // Uncomment if the cells are self-sizing
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44

        setUpBindings()
    }

    deinit {
        // Don't forget to remove the observers here
    }

    func setUpBindings() {
        viewModel.imageUrl.asObservable().subscribe { [weak self] (event) in
            guard let imageUrl = event.element else { return }
            self?.performerImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "favorite"))
            }.disposed(by: disposeBag)
        viewModel.name.asObservable().bind(to: nameLabel.rx.text).disposed(by: disposeBag)

        tableView
            .rx.observe(CGPoint.self, "contentOffset")
            .subscribe(onNext: { [weak self] contentOffset in
                if contentOffset != nil {
                    self?.imageViewBottomConstraint.constant = min((contentOffset?.y ?? 0.0), 0.0)
                    self?.view.layoutIfNeeded()
                }
            }).disposed(by: disposeBag)

        // MARK: - Cell Binding

        viewModel.dataSource.configureCell = { [weak self] dataSource, tableView, indexPath, item in
            return (self?.bindCell(tableView, item))!
        }

        // MARK: - Section Binding

        viewModel.sections.asObservable()
            .bind(to: tableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)

        // MARK: - Selection Handling

        tableView.rx
            .modelSelected(Bindable.self)
            .subscribe(onNext: { value in
                print("Tapped `\(value)`")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Helper Methods

    func bindCell(_ tableView: UITableView, _ item: Bindable) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(type(of: item))Cell")
        if let bindableCell = cell as? ReactiveBindable {
            bindableCell.bind(to: item)
        }
        return cell!
    }

}

// MARK: - Interface Builder Actions

extension EventDetailsViewController {

}

// MARK: - Notification handlers can be placed here

extension EventDetailsViewController {

}
