//
//  UserData.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 12. 12..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation
import ObjectMapper

class UserData: BaseResponse, Hashable, Equatable {
    var hashValue: Int { return userId.hashValue }
    
    static func == (lhs: UserData, rhs: UserData) -> Bool {
        return lhs.userId == rhs.userId
    }
    
    // MARK: - Model Properties
    var userId: String! = ""
    var fullName: String! = ""
    var provider: String?
    var authToken: String?
    var profileImageUrl: String?
    var socialToken: String?
    var billingName: String?
    var billingAddress: String?
    var email: String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override init() {
        super.init()!
    }
    
    override func mapping(map: Map) {
        userId <- map["id"]
        fullName <- map["full_name"]
        provider <- map["provider"]
        authToken <- map["auth_token"]
        profileImageUrl <- map["profile_image_url"]
        socialToken <- map["social_token"]
        billingName <- map["billing_name"]
        billingAddress <- map["billing_address"]
        email <- map["email"]
    }
}

