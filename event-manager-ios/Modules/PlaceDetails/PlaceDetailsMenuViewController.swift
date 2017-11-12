//
//  PlaceDetailsMenuViewController.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 11. 12..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import UIKit

class PlaceDetailsMenuViewController: UIAlertController {

    var place: Place!
    
    fileprivate let cancelActionButton = UIAlertAction(title: "PlaceDetails.ContextMenu.Cancel".localized, style: .cancel)
    
    fileprivate let getDirectionsActionButton = UIAlertAction(title: "PlaceDetails.ContextMenu.GetDirections".localized, style: .default) { _ -> Void in
        NotificationCenter.default.post(name: Constants.Notifications.PlaceDetailsContextAction, object: Constants.Notifications.PlaceDetailsGetDirections)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addAction(cancelActionButton)

        if place.location != nil {
            addAction(getDirectionsActionButton)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(actionTriggered(_:)), name: Constants.Notifications.PlaceDetailsContextAction, object: nil)
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
