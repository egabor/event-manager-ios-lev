//
//  Configuration.swift
//  event-manager-ios
//
//  Created by Career Mode on 2017. 10. 01..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import UIKit

struct Configuration {
	lazy var environment: Environment = {
		if let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String {
			if configuration.range(of: "Debug Mock") != nil {
				return Environment.mock
			} else if configuration.range(of: "Debug Staging") != nil {
				return Environment.staging
			}
		}
		return Environment.release
	}()
}

enum Environment: String {
	case mock
	case staging
	case release

	var baseURL: String {
		switch self {
		case .mock: return ""
		case .staging: return ""
		case .release: return ""
		}
	}

}
