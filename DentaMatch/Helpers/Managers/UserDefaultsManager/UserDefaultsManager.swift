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
    
    static let sharedInstance = UserDefaults()
    
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
}