//
//  MapMenuViewController.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 11. 12..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import UIKit

class MapMenuViewController: UIAlertController {

    var place: Place!

    fileprivate let cancelActionButton = UIAlertAction(title: "Map.ContextMenu.Cancel".localized, style: .cancel)

    fileprivate let showDetailsActionButton = UIAlertAction(title: "Map.ContextMenu.PlaceDetails".localized, style: .default) { _ -> Void in
        NotificationCenter.default.post(name: Constants.Notifications.MapContextAction, object: Constants.Notifications.MapShowPlaceDetails)
    }

    fileprivate let getDirectionsActionButton = UIAlertAction(title: "Map.ContextMenu.GetDirections".localized, style: .default) { _ -> Void in
        NotificationCenter.default.post(name: Constants.Notifications.MapContextAction, object: Constants.Notifications.MapGetDirections)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addAction(cancelActionButton)
        if place.hasDetails == true {
            addAction(showDetailsActionButton)
        }
        if place.location != nil {
            addAction(getDirectionsActionButton)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(actionTriggered(_:)), name: Constants.Notifications.MapContextAction, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func actionTriggered(_ notification: Notification) {
        guard let name = notification.object as? NSNotification.Name else { return }
        NotificationCenter.default.post(name: name, object: place)
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

}
