//
//  EventCell.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 07..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SDWebImage
import SwiftyAttributes

class EventCell: UITableViewCell {

    // MARK: - let constants

    let disposeBag = DisposeBag()

    // The viewmodel must be let!
    // To prevent memory leaks change the model inside the viewmodel instead of changing the viewmodel object.
    let viewModel = EventCellViewModel()

    // MARK: - var variables

    // MARK: - Interface Builder Outlets
    @IBOutlet weak var performerImageWrapperView: UIView!
    @IBOutlet weak var performerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var toggleFavoriteButton: UIButton!

    // MARK: - UITableViewCell Lifecycle Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        performerImageWrapperView.layer.borderWidth = 2.0
        performerImageWrapperView.layer.borderColor = UIColor.black.cgColor
        setUpBindings()
    }

    deinit {
        // Don't forget to remove the observers here
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Helper Methods

    override func layoutSubviews() {
        super.layoutSubviews()
        performerImageWrapperView.layer.cornerRadius = performerImageWrapperView.bounds.height / 2.0
        performerImageView.layer.cornerRadius = performerImageView.bounds.height / 2.0
    }

}

// MARK: - Reacive Bindable Implementation

extension EventCell: ReactiveBindable {

    func setUpBindings() {
        viewModel.imageUrl.asObservable().subscribe { [weak self] (event) in
            guard let imageUrl = event.element else { return }
            self?.performerImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder"))
        }.disposed(by: disposeBag)
        viewModel.name.asObservable().bind(to: nameLabel.rx.text).disposed(by: disposeBag)
        Observable.combineLatest(viewModel.displayPriority.asObservable(), viewModel.startDate.asObservable(), viewModel.placeName.asObservable()) { [weak self] (displayPriority, startDate, placeName) in
            guard let strongSelf = self else { return }
            if displayPriority == EventGroupOption.places {
                if var dateString = startDate.toString(format: "yyyy. MM. dd."),
                    let timeString = startDate.toString(format: "hh:mm a") {
                    dateString.append(" - ")
                    strongSelf.infoLabel.attributedText = dateString.withTextColor(strongSelf.infoLabel.textColor) + timeString.withFont(.boldSystemFont(ofSize: strongSelf.infoLabel.font.pointSize))
                }
            } else if displayPriority == EventGroupOption.months {
                if var dateString = startDate.toString(format: "yyyy. MM. dd."),
                    let timeString = startDate.toString(format: "hh:mm a") {
                    dateString.append(" - ")
                    strongSelf.infoLabel.attributedText = dateString.withTextColor(strongSelf.infoLabel.textColor) + timeString.withFont(.boldSystemFont(ofSize: strongSelf.infoLabel.font.pointSize))
                }
            } else {
                strongSelf.infoLabel.text = placeName
            }
        }.subscribe().disposed(by: disposeBag)
        viewModel.isFavorite.asObservable().bind(to: toggleFavoriteButton.rx.isSelected).disposed(by: disposeBag)
    }

    func bind(to model: Bindable?) {
        guard let model = model as? Event else { return }
        viewModel.model = model
    }

}

// MARK: - Interface Builder Actions

extension EventCell {
    @IBAction func toggleFavorite(_ sender: UIButton) {
        guard let event = viewModel.model else { return }
        viewModel.model?.isFavorite = !event.isFavorite
        viewModel.isFavorite.value = !viewModel.isFavorite.value
        NotificationCenter.default.post(name: Constants.Notifications.EventFavoriteStateUpdated, object: viewModel.model)
    }
}

// MARK: - Notification handlers can be placed here

extension EventCell {

}
