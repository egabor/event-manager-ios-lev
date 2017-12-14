//
//  EventDetailDescriptionCell.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 15..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class EventDetailDescriptionCell: UITableViewCell {

    // MARK: - let constants

    let disposeBag = DisposeBag()

    // The viewmodel must be let!
    //To prevent memory leaks change the model inside the viewmodel instead of changing the viewmodel object.
    let viewModel = EventDetailDescriptionCellViewModel()

    // MARK: - var variables

    // MARK: - Interface Builder Outlets
    @IBOutlet weak var descriptionLabel: UILabel!

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

extension EventDetailDescriptionCell: ReactiveBindable {

    func setUpBindings() {
        viewModel.description.asObservable().bind(to: descriptionLabel.rx.text).disposed(by: disposeBag)
    }

    func bind(to model: Bindable?) {
        guard let model = model as? EventDetailDescription else { return }
        viewModel.model = model
    }

}

// MARK: - Interface Builder Actions

extension EventDetailDescriptionCell {

}

// MARK: - Notification handlers can be placed here

extension EventDetailDescriptionCell {

}
