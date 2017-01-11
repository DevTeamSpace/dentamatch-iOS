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
let kLogEnabled = true
let kGoogleAPIKey = "AIzaSyDFWCamiO9WGTth-iOxfY_L0K6oRBeAu0U"

let kOkButtonTitle = "Ok"

struct Constants {
    
    static let BASE_URL = Constants.apiBaseURL()

    static func apiBaseURL() -> String {
        return ConfigurationManager.sharedManager.APIEndpoint()
    }
    
    struct Heading {
        static let heading1 = "Find Jobs Near You"
        static let heading2 =  "Set Your Availability"
        static let heading3 = "Get Quick Assignments"
        static let heading4 =  "Create \nYour Profile"
    }
    
    struct SubHeading {
        static let subHeading1 = "Quis nostrud exercitullamco laboris nisi ut aliquip consequat.quis nostrud exercitullamco laboris nisi ut."
        static let subHeading2 = "Quis nostrud exercitullamco laboris nisi ut aliquip consequat.quis nostrud exercitullamco laboris nisi ut."
        static let subHeading3 = "Quis nostrud exercitullamco laboris nisi ut aliquip consequat.quis nostrud exercitullamco laboris nisi ut."
        static let subHeading4 = "Quis nostrud exercitullamco laboris nisi ut aliquip consequat.quis nostrud exercitullamco laboris nisi ut."
    }
    
    struct Color {
        
        static let toolBarColor = UIColor.color(withHexCode: "10193e")
        
        static let textFieldTextColor = UIColor.color(withHexCode: "383838")
        static let textFieldLeftViewModeColor = UIColor.color(withHexCode: "aaafb8")
        static let textFieldBorderColor = UIColor.color(withHexCode: "e4e4e4")
        static let textFieldColorSelected = UIColor.color(withHexCode: "0470c0")
        static let textFieldPlaceHolderColor =  UIColor.color(withHexCode: "959595")
        
        static let profileProgressBarColor = UIColor.color(withHexCode: "a3d977")
        static let profileProgressBarTrackColor = UIColor.color(withHexCode: "f4f4f4")
        
        static let navBarColor = UIColor.color(withHexCode: "10193e")
        static let navBarColorForExperienceScreen = UIColor.color(withHexCode: "f7f7f7")
        static let navHeadingForExperienceScreen = UIColor(red: 9.0/255.0, green: 41.0/255.0, blue: 97.0/255.0, alpha: 1)
        
        static let loaderRingColor = UIColor.color(withHexCode: "10193e")
        static let loaderBackgroundColor = UIColor.color(withHexCode: "959595")

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
        
        struct SegueIdentifier {
            static let goToStudyVC = "goToStudyVC"
            static let goToSkillsVC = "goToSkillsVC"
            static let goToAffiliationsVC = "goToAffiliationsVC"
            static let goToCertificationsVC = "goToCertificationsVC"
            static let goToExecutiveSummaryVC = "goToExecutiveSummaryVC"
            static let goToLicense = "goToLicense"
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
        static let getJobTitleAPI = Constants.API.apiURL("list-jobtitle")
        static let uploadImageAPI = Constants.API.apiURL("users/upload-image")

        static func apiURL(_ methodName: String) -> String {
            return BASE_URL + methodName
        }
    }
    
    struct ServerKey {
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
        static let result = "result"
        static let accessToken = "accessToken"
        static let skillList = "joblists"
    }
    
    //MARK:- UserDefault Keys
    struct UserDefaultsKey {
        static let isLoggedIn = "isLoggedIn"
        static let deviceToken = "kDeviceToken"
        static let accessToken = "kDeviceToken"

    }
    
    //MARK:- Alert Messages
    struct AlertMessage{
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
    
    struct TextFieldMaxLenght {
        static let commonMaxLenght = 30
        static let licenseNumber = 15
        static let passwordLenght = 14
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



