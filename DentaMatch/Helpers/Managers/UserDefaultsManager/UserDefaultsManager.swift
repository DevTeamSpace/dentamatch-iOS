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
            if(kUserDefaults.value(forKey: Constants.UserDefaultsKey.isLoggedIn) != nil){
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
            if(kUserDefaults.value(forKey: Constants.UserDefaultsKey.kDeviceToken) != nil){
                return kUserDefaults.value(forKey: Constants.UserDefaultsKey.kDeviceToken) as! String
            }
            //Default is not logged in
            return ""
        }
        set {
            kUserDefaults.setValue(newValue, forKey: Constants.UserDefaultsKey.kDeviceToken)
            kUserDefaults.synchronize()
        }
    }
}
