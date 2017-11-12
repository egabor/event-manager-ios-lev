//
//  NewsCell.swift
//  event-manager-ios
//
//  Created by Gabor Nagy on 2017. 10. 26..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SDWebImage

class NewsCell: UITableViewCell {

    // MARK: - let constants

    let disposeBag = DisposeBag()
    let viewModel = NewsCellViewModel()

    // MARK: - var variables

    // MARK: - Interface Builder Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newsImageWrapperView: UIView!
    @IBOutlet weak var newsImageView: UIImageView!

    // MARK: - UITableViewCell Lifecycle Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        newsImageWrapperView.layer.borderWidth = 2.0
        newsImageWrapperView.layer.borderColor = UIColor.black.cgColor
       setUpBindings()
    }

    // MARK: - Helper Methods

    override func layoutSubviews() {
        super.layoutSubviews()
        newsImageWrapperView.layer.cornerRadius = newsImageWrapperView.bounds.height / 2.0
        newsImageView.layer.cornerRadius = newsImageView.bounds.height / 2.0
    }
}

// MARK: - Reacive Bindable Implementation

extension NewsCell: ReactiveBindable {

    func setUpBindings() {
        viewModel.imageUrl.asObservable().subscribe { [weak self] (event) in
            guard let imageUrl = event.element else { return }
            self?.newsImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "favorite"))
            }.disposed(by: disposeBag)
        viewModel.title.asObservable().bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.showOnDate.asObservable().bind(to: dateLabel.rx.text).disposed(by: disposeBag)
    }

    func bind(to model: Bindable?) {
        guard let model = model as? News else { return }
        viewModel.model = model
    }

}
