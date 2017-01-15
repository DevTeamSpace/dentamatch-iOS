//
//  UserManager.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 15/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

let ACTIVE_USER_KEY = "activeUser"
let LOGGED_USER_EMAIL_KEY = "userEmail"

class UserManager: NSObject {
    
    private var _activeUser: User?
    var callingController:UIViewController?
    
    var activeUser: User! {
        get {
            return _activeUser
        }
        set {
            _activeUser = newValue
            
            if let _ = _activeUser {
                self.saveActiveUser()
            }
        }
    }
    
    // MARK: Singleton Instance
    private static let _sharedManager = UserManager()
    
    class func sharedManager() -> UserManager {
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
        kUserDefaults.set(NSKeyedArchiver.archivedData(withRootObject: self.activeUser), forKey: ACTIVE_USER_KEY)
        
        if let email = self.activeUser.email {
            kUserDefaults.set(email, forKey: LOGGED_USER_EMAIL_KEY)
        }
        
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
    func loginHandler() {
        
    }
    func logoutHandler() {
        
    }
    
}
