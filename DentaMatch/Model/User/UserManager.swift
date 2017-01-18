//
//  UserManager.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 15/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import SwiftyJSON

let ACTIVE_USER_KEY = "activeUser"
let LOGGED_USER_EMAIL_KEY = "userEmail"

class UserManager: NSObject {
    
    private var activeUserP: User?
    var callingController:UIViewController?
    
    var activeUser: User! {
        get {
            return activeUserP
        }
        set {
            activeUserP = newValue
            
            if let _ = activeUserP {
                self.saveActiveUser()
            }
        }
    }
    
    // MARK: Singleton Instance
    private static let _sharedManager = UserManager()
    
    class func shared() -> UserManager {
        return _sharedManager
    }
    
    private override init() {
        // initiate any queues / arrays / filepaths etc
        super.init()
        
        // Load last logged user data if exists
        if isUserLoggedIn() {
            loadActiveUser()
        }
    }
    
    func isUserLoggedIn() -> Bool {
        
        guard let _ = kUserDefaults.object(forKey: ACTIVE_USER_KEY)
            else {
                return false
        }
        loadActiveUser()
        return true
    }
    
    func userLogout() {
        
    }
    
    // MARK: - KeyChain / User Defaults / Flat file / XML
    
    /**
     Load last logged user data, if any
     */
    func loadActiveUser() {
        
        guard let decodedUser = kUserDefaults.object(forKey: ACTIVE_USER_KEY) as? NSData,
            let user = NSKeyedUnarchiver.unarchiveObject(with: decodedUser as Data) as? User
            else {
                return
        }
        self.activeUser = user
    }
    
    func lastLoggedUserEmail() -> String? {
        return kUserDefaults.object(forKey: LOGGED_USER_EMAIL_KEY) as? String
    }
    
    /**
     Save current user data
     */
    func saveActiveUser() {
        kUserDefaults.set(NSKeyedArchiver.archivedData(withRootObject: self.activeUser) as AnyObject?, forKey: ACTIVE_USER_KEY)
        kUserDefaults.synchronize()
        if let email = self.activeUser.email {
            kUserDefaults.set(email, forKey: LOGGED_USER_EMAIL_KEY)
        }
        kUserDefaults.synchronize()

        
    }
    
    /**
     Delete current user data
     */
    func deleteActiveUser() {
        // remove active user from storage
        kUserDefaults.removeObject(forKey: ACTIVE_USER_KEY)
        // free user object memory
        self.activeUser = nil
    }
}

extension UserManager {
    func loginResponseHandler(response:JSON?,completionHandler:((_ success:Bool,_ message:String)->())?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                let user  = User()
                let userDetails = response[Constants.ServerKey.result][Constants.ServerKey.userDetails]
                user.firstName = userDetails[Constants.ServerKey.firstName].stringValue
                user.lastName = userDetails[Constants.ServerKey.lastName].stringValue
                user.accessToken = userDetails[Constants.ServerKey.accessToken].stringValue
                user.email = userDetails[Constants.ServerKey.email].stringValue
                user.zipCode = userDetails[Constants.ServerKey.zipCode].stringValue
                user.preferredJobLocation = userDetails[Constants.ServerKey.preferredLocation].stringValue
                user.profileImageURL = userDetails[Constants.ServerKey.imageUrl].stringValue

                self.activeUser = user
//                self.saveActiveUser()
                UserDefaultsManager.sharedInstance.isLoggedIn = true

                completionHandler?(true,response[Constants.ServerKey.message].stringValue)
            
            } else {
                completionHandler?(false,response[Constants.ServerKey.message].stringValue)
            }

        }
    }
    
    func logoutResponseHandler() {
        
        //logout will be here 
    }
}
