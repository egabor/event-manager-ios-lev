//
//  Constants.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 03..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation

struct Constants {

	struct Notifications {
		static let StartLoadingIndicatorAnimation = NSNotification.Name(rawValue: "StartLoadingIndicatorAnimation")
		static let StopLoadingIndicatorAnimation = NSNotification.Name(rawValue: "StopLoadingIndicatorAnimation")
		static let ShowLoadingAnimationView = NSNotification.Name(rawValue: "ShowLoadingAnimationView")
		static let HideLoadingAnimationView = NSNotification.Name(rawValue: "HideLoadingAnimationView")
        
        static let EventFavoriteStateUpdated = NSNotification.Name(rawValue: "EventFavoriteStateUpdated")
	}
    
    static let DefaultEventFilter = "EventFilter.All.Text"

    
}
