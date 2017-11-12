//
//  PlaceDetailsViewController.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 11. 11..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MapKit

class PlaceDetailsViewController: UIViewController {

    // MARK: - let constants

    let disposeBag = DisposeBag()

    // The viewmodel must be let!
    // To prevent memory leaks change the model inside the viewmodel instead of changing the viewmodel object.
    let viewModel = PlaceDetailsViewModel()

    // MARK: - var variables

    // MARK: - Interface Builder Outlets

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewInvisibleConstraint: NSLayoutConstraint!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - ViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(getDirections(_:)), name: Constants.Notifications.PlaceDetailsGetDirections, object: nil)

        tableView.dataSource = nil

         // Uncomment if the cells are self-sizing
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140

        /*
        // Uncomment in case of use custom section headers or footers
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 100
        tableView.sectionFooterHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionFooterHeight = 1
        */

        gradientView.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: gradientView.bounds, andColors: [UIColor.clear, UIColor.black])

        setUpBindings()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func setUpBindings() {

        viewModel.place.asObservable().map { $0.name }.bind(to: rx.title).disposed(by: disposeBag)
        viewModel.place.asObservable().map { $0.location.address }.bind(to: addressLabel.rx.text).disposed(by: disposeBag)
        viewModel.place.asObservable().map { $0.imageUrl == nil || $0.imageUrl!.isEmpty }.subscribe({ [weak self] (event) in
            guard let active = event.element else { return }
            self?.view.layoutIfNeeded()
            self?.imageViewInvisibleConstraint.isActive = active
        }).disposed(by: disposeBag)
        viewModel.place.asObservable().map { $0.imageUrl }.subscribe({ [weak self] (event) in
            guard let imageUrl = event.element, imageUrl != nil else { return }
            self?.placeImageView.sd_setImage(with: URL(string: imageUrl!), placeholderImage: UIImage(named: "favorite"))
        }).disposed(by: disposeBag)

        tableView
            .rx.observe(CGPoint.self, "contentOffset")
            .subscribe(onNext: { [weak self] contentOffset in
                //guard self?.viewModel.place.value.imageUrl?.isEmpty == false else { return }
                if contentOffset != nil {
                    self?.imageViewBottomConstraint.constant = min(contentOffset?.y ?? 0.0, 0.0)
                }
        }).disposed(by: disposeBag)

        viewModel.bottomConstraintOffset.asObservable().bind(to: imageViewBottomConstraint.rx.constant).disposed(by: disposeBag)

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

// MARK: - TableView Delegate Methods

extension PlaceDetailsViewController: UITableViewDelegate {

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

extension PlaceDetailsViewController {
    @IBAction func showContextMenu(_ sender: UIBarButtonItem) {
        let actionSheetController = PlaceDetailsMenuViewController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheetController.place = viewModel.place.value
        actionSheetController.popoverPresentationController?.sourceView = view
        self.present(actionSheetController, animated: true, completion: nil)
    }
}

// MARK: - Notification handlers can be placed here

extension PlaceDetailsViewController {
    @objc func getDirections(_ notification: Notification) {
        guard let place = notification.object as? Place else { return }

        let latitude: CLLocationDegrees = place.location.latitude
        let longitude: CLLocationDegrees = place.location.longitude
        let regionDistance: CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = place.name
        mapItem.openInMaps(launchOptions: options)
    }
}
