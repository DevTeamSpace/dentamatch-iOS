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
            if(kUserDefaults.value(forKey: Constants.UserDefaultsKeys.isLoggedIn) != nil){
                return kUserDefaults.value(forKey: Constants.UserDefaultsKeys.isLoggedIn) as! Bool
            }
            //Default is not logged in
            return false
        }
        set {
            kUserDefaults.setValue(newValue, forKey: Constants.UserDefaultsKeys.isLoggedIn)
            kUserDefaults.synchronize()
        }
    }
    
    var deviceToken:String {
        get {
            if(kUserDefaults.value(forKey: Constants.UserDefaultsKeys.kDeviceToken) != nil){
                return kUserDefaults.value(forKey: Constants.UserDefaultsKeys.kDeviceToken) as! String
            }
            //Default is not logged in
            return ""
        }
        set {
            kUserDefaults.setValue(newValue, forKey: Constants.UserDefaultsKeys.kDeviceToken)
            kUserDefaults.synchronize()
        }
    }
}
