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

let kCustomDesignFont = "dentamatch"
let kToolbarColor = "EF000C"
let kLogEnabled = true
let kGoogleAPIKey = "AIzaSyDFWCamiO9WGTth-iOxfY_L0K6oRBeAu0U"
let kTextFieldTextColor = UIColor.color(withHexCode: "383838")
let kTextFieldLeftViewModeColor = UIColor.color(withHexCode: "aaafb8")
let kTextFieldColor =  UIColor.color(withHexCode: "959595")
let kTextFieldColorSelected = UIColor.color(withHexCode: "0470c0")
let kTextFieldBorderColor = UIColor.color(withHexCode: "e4e4e4")
let kNavBarColor = "10193e"
let kOkButtonTitle = "Ok"

struct Constants {
    
    static let BASE_URL = Constants.apiBaseURL()

    static func apiBaseURL() -> String {
        return ConfigurationManager.sharedManager.APIEndpoint()
    }
    //MARK:- StoryBoards
    struct StoryBoard {
        static let registrationStoryboard  = "Registration"
        static let profileStoryboard  = "Profile"
 
        struct Identifer {
            static let registrationNav = "RegistrationNAV"
            static let profileNav  = "ProfileNAV"
        }
    }
    
    //MARK:- API Urls
    struct APIMethods {
        //APIs
        static let registrationAPI = Constants.APIMethods.apiURL("register")
        
        static func apiURL(_ methodName: String) -> String {
            return BASE_URL + "/" + methodName
        }
    }
     
    //MARK:- UserDefault Keys
    struct UserDefaultsKeys {
        static let isLoggedIn = "isLoggedIn"
    }
    
    //MARK:- Alert Messages
    struct AlertMessages{
        static let invalidEmail = "Please enter correct email ID"
        static let skipProfile = "Completed job profile will help you in applying for jobs."
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
}



