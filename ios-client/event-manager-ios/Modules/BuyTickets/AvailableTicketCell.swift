//
//  AvailableTicketCell.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 12. 16..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AvailableTicketCell: UITableViewCell {

    // MARK: - let constants

    let disposeBag = DisposeBag()

    // The viewmodel must be let!
    // To prevent memory leaks change the model inside the viewmodel instead of changing the viewmodel object.
    let viewModel = AvailableTicketCellViewModel()

    // MARK: - var variables

    // MARK: - Interface Builder Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!

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

extension AvailableTicketCell: ReactiveBindable {

    func setUpBindings() {
        viewModel.title.asObservable().bind(to: titleLabel.rx.text).disposed(by: disposeBag)
    }

    func bind(to model: Bindable?) {
        guard let model = model as? Ticket else { return }
        viewModel.model = model
    }

}

// MARK: - Interface Builder Actions

extension AvailableTicketCell {
    
    @IBAction func puchaseTicket(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PurchaseTicket"), object: viewModel.model)
    }

}

// MARK: - Notification handlers can be placed here

extension AvailableTicketCell {

}
