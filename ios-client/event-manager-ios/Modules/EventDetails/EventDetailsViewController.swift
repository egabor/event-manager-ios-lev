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
import ChameleonFramework

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
    @IBOutlet weak var gradientView: UIView!

    @IBOutlet weak var performerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var ticketLabel: UILabel!
    @IBOutlet weak var facebookEventLabel: UILabel!
    @IBOutlet weak var seeAllButton: UIButton!
    @IBOutlet weak var relatedEventsButton: UIButton!

    // MARK: - ViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = nil

        // Uncomment if the cells are self-sizing
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44

        gradientView.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: gradientView.bounds, andColors: [UIColor.clear, UIColor.black])

        setUpBindings()
    }

    deinit {
        // Don't forget to remove the observers here
    }

    func setUpBindings() {
        viewModel.imageUrl.asObservable().subscribe { [weak self] (event) in
            guard let imageUrl = event.element else { return }
            self?.performerImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder"))
            }.disposed(by: disposeBag)
        viewModel.name.asObservable().bind(to: nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.isFavorite.asObservable().subscribe { [weak self] (event) in
            guard let isFavorite = event.element else { return }
            var favoriteItem: UIBarButtonItem!
            if isFavorite {
                favoriteItem = UIBarButtonItem(image: UIImage(named: "favorite_filled"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(self?.toggleFavorite))
            } else {
                favoriteItem = UIBarButtonItem(image: UIImage(named: "favorite"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(self?.toggleFavorite))
            }
            self?.navigationItem.rightBarButtonItems = [favoriteItem]

            }.disposed(by: disposeBag)

        viewModel.startTimeInfo.asObservable().bind(to: startTimeLabel.rx.text).disposed(by: disposeBag)
        viewModel.placeInfo.asObservable().bind(to: placeLabel.rx.text).disposed(by: disposeBag)
        viewModel.ticketInfo.asObservable().bind(to: ticketLabel.rx.text).disposed(by: disposeBag)
        viewModel.facebookEventInfo.asObservable().bind(to: facebookEventLabel.rx.text).disposed(by: disposeBag)

        tableView
            .rx.observe(CGPoint.self, "contentOffset")
            .subscribe(onNext: { [weak self] contentOffset in
                if contentOffset != nil {
                    self?.imageViewBottomConstraint.constant = min(contentOffset?.y ?? 0.0, 0.0)
                }
            }).disposed(by: disposeBag)

        viewModel.bottomConstraintOffset.asObservable().bind(to: imageViewBottomConstraint.rx.constant).disposed(by: disposeBag)
        
        viewModel.hasRelatedEvents.asObservable().map { !$0 }.bind(to: relatedEventsButton.rx.isHidden).disposed(by: disposeBag)

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowPlaceDetails" {
            if let destination = segue.destination as? PlaceDetailsViewController {
                if let place = sender as? Place {
                    destination.viewModel.place.value = place
                }
            }
        } else if segue.identifier == "ShowRelatedEvents" {
            if let destination = segue.destination as? RelatedEventsTableViewController {
                if let event = sender as? Event {
                    destination.viewModel.event.value = event
                }
            }
        } else if segue.identifier == "ShowAvailableTickets" {
            if let destination = segue.destination as? BuyTicketsTableViewController {
                destination.viewModel.event = viewModel.model
                destination.viewModel.items.value = viewModel.model?.availableTickets ?? []
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

}

// MARK: - Interface Builder Actions

extension EventDetailsViewController {
    @objc func toggleFavorite() {
        guard let event = viewModel.model else { return }
        viewModel.model?.isFavorite = !event.isFavorite
        viewModel.isFavorite.value = !viewModel.isFavorite.value
        NotificationCenter.default.post(name: Constants.Notifications.EventFavoriteStateUpdated, object: viewModel.model)
    }

    @IBAction func seeAllForThisPlace(_ sender: UIButton) {
        print("See All")
        guard let event = viewModel.model else { return }
        performSegue(withIdentifier: "ShowPlaceDetails", sender: event.place)
    }

    @IBAction func showRelatedEvents(_ sender: UIButton) {
        print("Show Related Events")
        guard let event = viewModel.model else { return }
        performSegue(withIdentifier: "ShowRelatedEvents", sender: event)
    }

    @IBAction func showAvailableTickets(_ sender: UIGestureRecognizer) {
        if viewModel.model?.availableTickets?.count ?? 0 > 0 {
            if ReferenceManager.shared.userData == nil {
                let loginAlert = UIAlertController(title: "Alert".localized, message: "This action requires login.".localized, preferredStyle: UIAlertControllerStyle.alert)
                loginAlert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
                loginAlert.addAction(UIAlertAction(title: "Login".localized, style: .default, handler: { _ in
                    Authenticator.shared.authenticate(with: .facebook) { [weak self] (user, error) in
                        guard let strongSelf = self else { return }
                        if error != nil {
                            let alert = UIAlertController(title: "Error".localized, message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Dismiss".localized, style: UIAlertActionStyle.default, handler: nil))
                            strongSelf.present(alert, animated: true, completion: nil)
                        }
                        if user != nil {
                            RestClient.shared.getProfile { [weak self] (userData, error) in
                                guard let strongSelf = self  else { return }
                                if error != nil {
                                    print("Error: \(String(describing: error))")
                                }
                                if let userData = userData {
                                    ReferenceManager.shared.userData = userData
                                    strongSelf.performSegue(withIdentifier: "ShowAvailableTickets", sender: nil)
                                }
                                
                            }
                        }
                    }
                }))
                self.present(loginAlert, animated: true, completion: nil)
            } else {
                performSegue(withIdentifier: "ShowAvailableTickets", sender: nil)
            }
        }
    }
}

// MARK: - Notification handlers can be placed here

extension EventDetailsViewController {

}
