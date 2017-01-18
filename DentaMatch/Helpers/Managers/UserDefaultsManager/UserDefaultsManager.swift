//
//  UserDefaults.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import Foundation

class UserDefaultsManager: NSObject {
    
    static let sharedInstance = UserDefaultsManager()
    
    var isLoggedIn:Bool {
        get {
            if kUserDefaults.value(forKey: Constants.UserDefaultsKey.isLoggedIn) != nil {
                return kUserDefaults.value(forKey: Constants.UserDefaultsKey.isLoggedIn) as! Bool
            }
            //Default is not logged in
            return false
        }
        set {
            kUserDefaults.setValue(newValue, forKey: Constants.UserDefaultsKey.isLoggedIn)
            kUserDefaults.synchronize()
        }
    }
    
    var deviceToken:String {
        get {
            if kUserDefaults.value(forKey: Constants.UserDefaultsKey.deviceToken) != nil {
                return kUserDefaults.value(forKey: Constants.UserDefaultsKey.deviceToken) as! String
            }
            return ""
        }
        set {
            kUserDefaults.setValue(newValue, forKey: Constants.UserDefaultsKey.deviceToken)
            kUserDefaults.synchronize()
        }
    }
    
    var accessToken:String {
        get {
            if kUserDefaults.value(forKey: Constants.UserDefaultsKey.accessToken) != nil {
                return kUserDefaults.value(forKey: Constants.UserDefaultsKey.accessToken) as! String
            }
            return ""
        }
        set {
            kUserDefaults.setValue(newValue, forKey: Constants.UserDefaultsKey.accessToken)
            kUserDefaults.synchronize()
        }
    }
    
    var profileImageURL:String {
        get {
            if kUserDefaults.value(forKey: Constants.UserDefaultsKey.profileImageURL) != nil {
                return kUserDefaults.value(forKey: Constants.UserDefaultsKey.profileImageURL) as! String
            }
            return ""
        }
        set {
            kUserDefaults.setValue(newValue, forKey: Constants.UserDefaultsKey.profileImageURL)
            kUserDefaults.synchronize()
        }
    }
    
    var licenseImageURL:String {
        get {
            if kUserDefaults.value(forKey: Constants.UserDefaultsKey.licenseImageURL) != nil {
                return kUserDefaults.value(forKey: Constants.UserDefaultsKey.licenseImageURL) as! String
            }
            return ""
        }
        set {
            kUserDefaults.setValue(newValue, forKey: Constants.UserDefaultsKey.licenseImageURL)
            kUserDefaults.synchronize()
        }
    }

    func clearCache() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
}
