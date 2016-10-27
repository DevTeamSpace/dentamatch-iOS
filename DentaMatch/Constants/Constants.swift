//
//  Constants.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import UIKit

let kUserDefaults = UserDefaults.standard
let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
let kToolbarColor = "EF000C"
let kLogEnabled = true
let kGoogleAPIKey = "AIzaSyDFWCamiO9WGTth-iOxfY_L0K6oRBeAu0U"

let kTextFieldColor = "e4e4e4"
let kNavBarColor = "0f183f"

//MARK:- StoryBoards
struct StoryBoard {
    static let registrationStoryboard  = "Registration"
}

//UserDefault Keys
struct UserDefaultsKeys {
    static let isLoggedIn = "isLoggedIn"
}

//MARK:- Alert Messages
struct AlertMessages{
    static let invalidEmail = "Please enter correct email ID"
    
    struct AlertTitle {
        static let invalidEmailTitle = ""
    }
}

//MARK:- Strings
struct Strings{
    static let whiteSpace = " "
}

//MARK:- Hardcoded Limits
struct Limits{
    static let licenseNumberLimit = 16
}


