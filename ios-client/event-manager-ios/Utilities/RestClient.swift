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
    var places = Variable([Place]())
    var news = Variable([News]())

    private init() {}

    public func getEvents(completionBlock: (([Event], String?) -> Void)?) {
        let url = URL(string: configuration.environment.baseURL + "/events")!

        // TODO: send the correct headers
        Alamofire.request(url, method: .delete, encoding: JSONEncoding.default, headers: [:]).responseArray { [weak self] (response: DataResponse<[Event]>) in
            if response.result.isSuccess {
                guard let strongSelf = self else { return }
                guard let result = response.result.value else { return }
                self?.events.value = result
                completionBlock?(result, nil)
            }
        }
    }

    public func getPlaces(completionBlock: (([Place], String?) -> Void)?) {
        let url = URL(string: configuration.environment.baseURL + "/places")!

        // TODO: send the correct headers
        Alamofire.request(url, method: .delete, encoding: JSONEncoding.default, headers: [:]).responseArray { [weak self] (response: DataResponse<[Place]>) in
            if response.result.isSuccess {
                guard let strongSelf = self else { return }
                guard let result = response.result.value else { return }
                self?.places.value = result
                completionBlock?(result, nil)
            }
        }
    }

    public func getNews(completionBlock: (([News], String?) -> Void)?) {
        let url = URL(string: configuration.environment.baseURL + "/news")!

        // TODO: send the correct heders
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: [:]).responseArray { [weak self] (response: DataResponse<[News]>) in
            if response.result.isSuccess {
                guard let strongSelf = self else { return }
                guard let result = response.result.value else { return }
                self?.news.value = result
                completionBlock?(result, nil)
            }
        }
    }
    
    public func getProfile(_ userId: String = "me", completionBlock: ((UserData?, String?) -> Void)?) {
        let url = URL(string: "https://us-central1-event-manager-1400e.cloudfunctions.net" + "/users/\(userId)")!
        var headers = [String: String]()
        if userId == "me" {
            headers["UserId"] = ReferenceManager.shared.userData?.userId ?? ""
            if ReferenceManager.shared.userData?.authToken != nil {
                headers["Auth-Token"] = ReferenceManager.shared.userData?.authToken
            }
        } else {
            headers["UserId"] = userId
        }
        
        // TODO: send the correct headers
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseObject { (response: DataResponse<UserData>) in
            if response.result.isSuccess {
                guard let result = response.result.value else { return }
                completionBlock?(result, nil)
            }
        }
    }
    
    public func editProfile(_ userId: String = "me", completionBlock: ((UserData?, String?) -> Void)?) {
        let url = URL(string: configuration.environment.baseURL + "/users/\(userId)")!
        
        // TODO: send the correct headers
        Alamofire.request(url, method: .post, encoding: JSONEncoding.default, headers: [:]).responseObject { (response: DataResponse<UserData>) in
            if response.result.isSuccess {
                guard let result = response.result.value else { return }
                completionBlock?(result, nil)
            }
        }
    }
}
