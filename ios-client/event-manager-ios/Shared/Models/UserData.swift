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
    
    
    init?(_ userId: String, _ fullName: String, _ email: String? = "", _ profileImageUrl: String? = nil, _ billingName: String? = nil, _ billingAddress: String? = nil) {
        super.init()
        self.userId = userId
        self.fullName = fullName
        self.email = email
        self.profileImageUrl = profileImageUrl
        self.billingName = billingName
        self.billingAddress = billingAddress
    }
    
    init?(_ userId: String, _ data: [String: Any]) {
        super.init()
        self.userId = userId
        self.fullName = data["fullName"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.billingName = data["billingName"] as? String ?? ""
        self.billingAddress = data["billingAddress"] as? String ?? ""
    }
}

