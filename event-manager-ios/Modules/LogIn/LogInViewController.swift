//
//  LogInViewController.swift
//  event-manager-ios
//
//  Created by Career Mode on 2017. 10. 01..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class LogInViewController: UIViewController {

    // MARK: - let constants

    let disposeBag = DisposeBag()

    // The viewmodel must be let!
    // To prevent memory leaks change the model inside the viewmodel instead of changing the viewmodel object.
    let viewModel = LogInViewModel()

    // MARK: - var variables

    // MARK: - Interface Builder Outlets
	@IBOutlet weak var loadingView: UIView!

    // MARK: - UIViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
		view.addSubview(loadingView)
		loadingView.snp.makeConstraints { (make) in
			make.center.size.equalToSuperview()
		}

		// TODO: Do the viewmodel binding here
    }

    deinit {
        // Don't forget to remove the observers here
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

	func showLoading() {
		loadingView.alpha = 1.0
		NotificationCenter.default.post(Notification(name: Constants.Notifications.ShowLoadingAnimationView))
	}

	@objc func hideLoading() {
		let handler: (_ finished: Bool) -> Void = { [weak self] (finished) -> Void in
			if finished {
				self?.loadingView.alpha = 0.0
			}
		}
		NotificationCenter.default.post(name: Constants.Notifications.HideLoadingAnimationView, object: handler)
	}

	@objc func hideModalLoading() {
		let handler: (_ finished: Bool) -> Void = { [weak self] (finished) -> Void in
			if finished {
				self?.dismiss(animated: true, completion: nil)
			}
		}
		NotificationCenter.default.post(name: Constants.Notifications.HideLoadingAnimationView, object: handler)
	}

}

// MARK: - Interface Builder Actions

extension LogInViewController {
	@IBAction func testLoading(_ sender: UIButton) {
		showLoading()
		
		perform(#selector(hideLoading), with: nil, afterDelay: 3.0)
	}
	
	@IBAction func testModalLoading(_ sender: UIButton) {
		performSegue(withIdentifier: "ShowModalLoading", sender: nil)
		NotificationCenter.default.post(Notification(name: Constants.Notifications.ShowLoadingAnimationView))
	
		perform(#selector(hideModalLoading), with: nil, afterDelay: 3.0)
	}
}

// MARK: - Notification handlers can be placed here

extension LogInViewController {

}
