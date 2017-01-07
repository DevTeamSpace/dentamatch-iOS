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
let kProfileProgressBarColor = UIColor.color(withHexCode: "a3d977")
let kProfileProgressBarTrackColor = UIColor.color(withHexCode: "f4f4f4")
let kNavBarColor = "10193e"
let kNavBarColorForExperienceScreen = "f7f7f7"
let kNavHeadingForExperienceScreen = UIColor(red: 9.0/255.0, green: 41.0/255.0, blue: 97.0/255.0, alpha: 1)

let kOkButtonTitle = "Ok"

struct Constants {
    
    static let BASE_URL = Constants.apiBaseURL()

    static func apiBaseURL() -> String {
        return ConfigurationManager.sharedManager.APIEndpoint()
    }
    
    struct DesignFont {
        static let acceptTermsSelected  = "w"
        static let acceptTermsDeSelected  = "t"
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
    struct API {
    
        //APIs
        static let registrationAPI = Constants.API.apiURL("users/sign-up")
        static let loginAPI = Constants.API.apiURL("users/sign-in")
        static let forgotPasswordAPI = Constants.API.apiURL("users/forgot-password")
        static let termsAndConditionsURL = Constants.API.apiURL("term-condition")
        static let privacyPolicyURL = Constants.API.apiURL("privacy-policy")

        static func apiURL(_ methodName: String) -> String {
            return BASE_URL + methodName
        }
    }
    
    struct ServerKeys {
        static let deviceId = "deviceId"
        static let deviceType = "deviceType"
        static let deviceToken = "deviceToken"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let email = "email"
        static let password = "password"
        static let preferredLocation = "preferedLocation"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let zipCode = "zipCode"
        static let userType = "userType"
        static let status = "status"
        static let statusCode = "statusCode"
        static let message = "message"
        static let userDetails = "userDetails"
    }
    
    //MARK:- UserDefault Keys
    struct UserDefaultsKeys {
        static let isLoggedIn = "isLoggedIn"
        static let kDeviceToken = "kDeviceToken"
    }
    
    //MARK:- Alert Messages
    struct AlertMessages{
        static let invalidEmail = "Please enter correct email ID"
        static let skipProfile = "Completed job profile will help you in applying for jobs."
        static let somethingWentWrong = "Something went wrong"
        
        static let jobTitle = "please enter job title"
        static let yearOfExperience = "please enter experience"
        static let officeName = "please enter office name"
        static let officeAddress = "please enter office address"
        static let CityName = "please enter city name"

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
        static let passwordLimit = 6

    }
}



