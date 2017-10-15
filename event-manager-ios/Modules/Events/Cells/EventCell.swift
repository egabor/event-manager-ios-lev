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

class EventCell: UITableViewCell {

    // MARK: - let constants

    let disposeBag = DisposeBag()

    // The viewmodel must be let!
    // To prevent memory leaks change the model inside the viewmodel instead of changing the viewmodel object.
    let viewModel = EventCellViewModel()

    // MARK: - var variables

    // MARK: - Interface Builder Outlets
    @IBOutlet weak var performerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel : UILabel!
    @IBOutlet weak var toggleFavoriteButton: UIButton!

    // MARK: - UITableViewCell Lifecycle Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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

}

// MARK: - Reacive Bindable Implementation

extension EventCell: ReactiveBindable {

    func setUpBindings() {
        viewModel.name.asObservable().bind(to: nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.info.asObservable().bind(to: infoLabel.rx.text).disposed(by: disposeBag)
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
        viewModel.isFavorite.value = !viewModel.isFavorite.value
        // TODO: post a notification about it
    }
}

// MARK: - Notification handlers can be placed here

extension EventCell {

}
