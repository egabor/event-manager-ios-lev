//
//  ReferenceManager.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 12. 13..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation
import Firebase

class ReferenceManager {
    static let shared = ReferenceManager()
    
    var userData: UserData?
    var user: User?

}
