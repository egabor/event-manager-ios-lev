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
        static let EventFilterUpdated = NSNotification.Name(rawValue: "EventFilterUpdated")
        static let PlaceTypesUpdated = NSNotification.Name(rawValue: "PlaceTypesUpdated")
        static let MapContextAction = NSNotification.Name(rawValue: "MapContextAction")
        static let MapGetDirections = NSNotification.Name(rawValue: "MapGetDirections")
        static let MapShowPlaceDetails = NSNotification.Name(rawValue: "MapShowPlaceDetails")
        static let PlaceDetailsContextAction = NSNotification.Name(rawValue: "PlaceDetailsContextAction")
        static let PlaceDetailsGetDirections = NSNotification.Name(rawValue: "PlaceDetailsGetDirections")
	}

    static let DefaultEventFilter = "EventFilter.All.Text"

}
