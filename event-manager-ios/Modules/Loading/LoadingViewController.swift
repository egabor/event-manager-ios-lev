//
//  LoadingViewController.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 03..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoadingViewController: UIViewController {
	typealias HideLoadingCompletionHandler = (_ finished: Bool) -> Void

    // MARK: - let constants

    let disposeBag = DisposeBag()

    // The viewmodel must be let!
    // To prevent memory leaks change the model inside the viewmodel instead of changing the viewmodel object.
    let viewModel = LoadingViewModel()

    // MARK: - var variables

    // MARK: - Interface Builder Outlets
	@IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    // MARK: - UIViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: Do the viewmodel binding here
		NotificationCenter.default.addObserver(self, selector: #selector(startLoading(_:)), name: Constants.Notifications.StartLoadingIndicatorAnimation, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(stopLoading(_:)), name: Constants.Notifications.StopLoadingIndicatorAnimation, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(show(_:)), name: Constants.Notifications.ShowLoadingAnimationView, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(hide(_:)), name: Constants.Notifications.HideLoadingAnimationView, object: nil)
	}

    deinit {
        NotificationCenter.default.removeObserver(self)
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

}

// MARK: - Interface Builder Actions

extension LoadingViewController {

}

// MARK: - Notification handlers can be placed here

extension LoadingViewController {
	@objc fileprivate func startLoading(_ notification: Notification) {
		print("startloading")
		loadingIndicator.startAnimating()
	}

	@objc fileprivate func stopLoading(_ notification: Notification) {
		print("stoploading")
		loadingIndicator.stopAnimating()
	}

	@objc fileprivate func show(_ notification: Notification) {
		UIView.animate(withDuration: 0.3, delay: 0.0, options: .beginFromCurrentState, animations: { [weak self] in
			self?.view.alpha = 1.0
		}) { [weak self] (_) in
			self?.loadingIndicator.startAnimating()
		}
	}

	@objc fileprivate func hide(_ notification: Notification) {
		UIView.animate(withDuration: 0.3, delay: 0.0, options: .beginFromCurrentState, animations: { [weak self] in
			self?.view.alpha = 0.0
		}) { [weak self] (finished) in
			if finished {
				if let handler = notification.object as? LoadingViewController.HideLoadingCompletionHandler {
					handler(finished)
				}
				self?.loadingIndicator.stopAnimating()
				
			}
		}
	}
}
