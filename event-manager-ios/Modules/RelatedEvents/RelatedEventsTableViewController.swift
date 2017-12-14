//
//  RelatedEventsTableViewController.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 12. 14..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RelatedEventsTableViewController: UITableViewController {

    // MARK: - let constants

    let disposeBag = DisposeBag()

    // The viewmodel must be let!
    // To prevent memory leaks change the model inside the viewmodel instead of changing the viewmodel object.
    let viewModel = RelatedEventsViewModel()

    // MARK: - var variables

    // MARK: - Interface Builder Outlets

    // MARK: - ViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = nil
        self.title = "RelatedEvents.Title".localized

        // Uncomment if the cells are self-sizing
        //tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.estimatedRowHeight = 44

        // TODO: Do the viewmodel binding here

        viewModel.items
            .asObservable()
            .bind(to: tableView.rx
                .items(cellIdentifier: "EventCell",
                       cellType: EventCell.self)) { (_, element, cell) in
                        cell.bind(to: element)
            }
            .disposed(by: disposeBag)

        tableView.rx
            .modelSelected(Event.self)
            .subscribe(onNext: { value in
                print("Tapped `\(value)`")
                if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                    self.tableView.deselectRow(at: selectedIndexPath, animated: true)
                }
                self.performSegue(withIdentifier: "ShowEventDetails", sender: value)
            })
            .disposed(by: disposeBag)

    }

    deinit {
        // Don't forget to remove the observers here
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
                model.relatedEvents = []
                destination.viewModel.model = model
            }
        }
    }
    

    // MARK: - Helper Methods

}

// MARK: - Interface Builder Actions

extension RelatedEventsTableViewController {

}

// MARK: - Notification handlers can be placed here

extension RelatedEventsTableViewController {

}
