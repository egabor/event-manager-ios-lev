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
import RxSwift

class RestClient {
    var configuration = Configuration()
    static let shared = RestClient()

    var events = Variable([Event]())
    var news = Variable([News]())

    private init() {}
    
    public func getEvents(complitionBlock: (([Event], String?) -> Void)?) {
        let url = URL(string: configuration.environment.baseURL + "/events")!
        
        // TODO: send the correct heders
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: [:]).responseArray { [weak self] (response: DataResponse<[Event]>) in
            if response.result.isSuccess {
                guard let result = response.result.value else { return }
                self?.events.value = result
                complitionBlock?(result, nil)
            }
        }
    }
    
    public func getNews(complitionBlock: (([News], String?) -> Void)?) {
        let url = URL(string: configuration.environment.baseURL + "/news")!
        
        // TODO: send the correct heders
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: [:]).responseArray { [weak self] (response: DataResponse<[News]>) in
            if response.result.isSuccess {
                guard let result = response.result.value else { return }
                self?.news.value = result
                complitionBlock?(result, nil)
            }
        }
    }
}
