//
//  RestClient.swift
//  event-manager-ios
//
//  Created by Career Mode on 2017. 10. 01..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import SwiftyJSON

class RestClient {
    var configuration = Configuration()
    static let shared = RestClient()

    private init() {}

    public func getEvents(complitionBlock: (([Event], String?) -> Void)?) {
        let url = URL(string: configuration.environment.baseURL + "/events")!

        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: [:]).responseArray { (response: DataResponse<[Event]>) in
            if response.result.isSuccess {
                let result: [Event] = response.result.value!
                complitionBlock!(result, nil)
            }
        }
    }
}
