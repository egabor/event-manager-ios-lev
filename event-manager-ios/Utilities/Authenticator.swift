//
//  Authenticator.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 12. 13..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import FBSDKLoginKit
import Firebase

//typealias Auth = Authenticator

enum Provider: String {
    case facebook
}

class Authenticator {
    static let shared = Authenticator()
    
    var viewController: UIViewController = UIViewController()
    let defaults = UserDefaults.standard
    let refManager = ReferenceManager.shared
    var handler: (User?, Error?) -> Swift.Void = {(user, error) in}
    
    private init() { //This prevents others from using the default '()' initializer for this class.
        
    }
    
    func authenticate(with provider: Provider, handler: @escaping (User?, Error?) -> Swift.Void) {
        self.handler = handler
        
        switch provider {
        case .facebook:
            facebookAuth()
        }
    }
    
    func facebookAuth() {
        print("FBSDKACCESSTOKEN: \(FBSDKAccessToken.current())")
        if FBSDKAccessToken.current() == nil {
            let facebookLogin = FBSDKLoginManager()
            facebookLogin.logIn(withReadPermissions: ["public_profile", "email"], from: viewController, handler: { [weak self]
                (facebookResult, facebookError) -> Void in
                if facebookError != nil {
                    print("Facebook login failed. Error \(facebookError)")
                    self?.handler(nil, facebookError)
                } else if (facebookResult?.isCancelled)! {
                    print("Facebook login was cancelled.")
                    self?.handler(nil, facebookError)
                } else {
                    // your firebase authentication stuff..
                    let token = FBSDKAccessToken.current().tokenString!
                    
                    let credential = FacebookAuthProvider.credential(withAccessToken: token)
                    
                    self?.firebaseAuth(credential: credential)
                }
            })
        } else {
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            self.firebaseAuth(credential: credential)
        }
    }
    
    func firebaseAuth(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { [weak self] (user, error) in
            guard let strongSelf = self else { return }
            
            if error != nil {
                print("Login failed. \(error)")
                self?.handler(nil, error)
            } else {
                ReferenceManager.shared.user = user
                print("Logged in! \(user?.displayName), \(user?.email), \(user?.photoURL)")

            }
        }
 
    }
}

