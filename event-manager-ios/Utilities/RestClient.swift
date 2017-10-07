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
            let json = JSON(data: response.data!)
            print("\n\nEvents:\n\(json)\n")
            if response.result.isSuccess {
                let result: [Event] = response.result.value!
                print("\n\nEvents2:\n\(response.result.value)\n")

                complitionBlock!(result, nil)
            } else {
                /*handleError(data: response.data!, complitionBlock: { (errorMessage: String) in
                    complitionBlock!(errorMessage, nil)
                })*/
            }
        }
        
        
    }
}
