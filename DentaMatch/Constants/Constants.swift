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
let kDeviceId = "com.appster.dentamatch.deviceId"
let kCustomDesignFont = "dentamatch"
let kLogEnabled = true
let kPlaceHolderImage = UIImage(named: "profileButton")
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
        static let textFieldErrorColor = UIColor.color(withHexCode: "ff0000")
        
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
        static let onBoardingStoryboard  = "Onboarding"

        static let registrationStoryboard  = "Registration"
        static let profileStoryboard  = "Profile"
        static let dashboardStoryboard  = "Dashboard"

        struct Identifer {
            static let registrationNav = "RegistrationNAV"
            static let profileNav  = "ProfileNAV"
            static let editProfileNav  = "EditProfileNAV"
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
        static let registration = Constants.API.apiURL("users/sign-up")
        static let login = Constants.API.apiURL("users/sign-in")
        static let forgotPassword = Constants.API.apiURL("users/forgot-password")
        static let termsAndConditionsURL = Constants.API.apiURL("term-condition")
        static let privacyPolicyURL = Constants.API.apiURL("privacy-policy")
        static let getJobTitle = Constants.API.apiURL("list-jobtitle")
        static let uploadImage = Constants.API.apiURL("users/upload-image")
        static let LicenseNumberAndState = Constants.API.apiURL("users/update-license")
        static let getSkillList = Constants.API.apiURL("list-skills")
        static let updateSkillList = Constants.API.apiURL("users/update-skill")
        static let getCertificationList = Constants.API.apiURL("list-certifications")
        static let getAboutMe = Constants.API.apiURL("users/about-me-list")
        static let saveAboutMe = Constants.API.apiURL("users/about-me-save")
        static let getAffiliationList = Constants.API.apiURL("users/affiliation-list")
        static let saveAffiliationList = Constants.API.apiURL("users/affiliation-save")
        static let getSchoolListAPI = Constants.API.apiURL("users/school-list")
        static let addSchoolAPI = Constants.API.apiURL("users/school-add")
        static let getJobTitleAPI = Constants.API.apiURL("list-jobtitle")
        static let uploadImageAPI = Constants.API.apiURL("users/upload-image")
        static let licenseNumberAndState = Constants.API.apiURL("users/update-license")
        static let workExperienceSave = Constants.API.apiURL("users/work-experience-save")
        static let getWorkExperience = Constants.API.apiURL("users/work-experience-list")
        static let deleteExperience = Constants.API.apiURL("users/work-experience-delete")
        static let updateCertificate = Constants.API.apiURL("users/update-certificate")
        static let updateValidationDates = Constants.API.apiURL("users/update-certificate-validity")
        static let userProfile = Constants.API.apiURL("users/user-profile")


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
        static let licenseNumber = "licenseNumber"
        static let state = "state"
        static let userDetails = "userDetails"
        static let result = "result"
        static let accessToken = "accessToken"
        static let joblists = "joblists"
        static let profileImageURL = "img_url"
        static let imageUrl = "imageUrl"
        static let list = "list"
        static let aboutMe = "aboutMe"
        static let affiliationDataArray = "affiliationDataArray"
        static let other = "other"
        static let affiliationId = "affiliationId"
        static let otherAffiliation = "otherAffiliation"
        static let validityDate = "validityDate"
        static let image = "image"
        static let profilePic = "profilePic"

        static let imageURL = "imagePath"
        static let imageURLForPostResponse = "imgUrl"

        static let experienceId = "id"
        static let userId = "userId"
        static let user = "user"
        static let jobTitleId = "jobTitleId"
        static let jobtitleName = "jobtitleName"
        static let monthsOfExperience = "monthsOfExpereince"
        static let officeName = "officeName"
        static let officeAddressExp = "officeAddress"
        static let cityName = "city"

        static let reference1Name = "reference1Name"
        static let reference1Mobile = "reference1Mobile"
        static let reference1Email = "reference1Email"
        static let reference2Name = "reference2Name"
        static let reference2Mobile = "reference2Mobile"
        static let reference2Email = "reference2Email"
        static let createdAt = "createdAt"
        static let skillList = "list"
        static let skillName = "skillName"
        static let otherSkill = "otherSkill"
        static let id = "id"
        static let parentId = "parentId"
        static let isSkillSelected = "userSkill"
        
        static let certificateName = "certificateName"
        static let schoolingId = "schoolingId"
        static let schoolName = "schoolName"
        static let schoolCategory = "schoolCategory"
        static let schoolChildName = "schoolChildName"
        static let schoolingChildId = "schoolingChildId"
        static let yearOfGraduation = "yearOfGraduation"
    }
    
    //MARK:- UserDefault Keys
    struct UserDefaultsKey {
        static let isLoggedIn = "isLoggedIn"
        static let deviceToken = "kDeviceToken"
        static let accessToken = "kDeviceToken"
        static let profileImageURL = "kProfileImageURL"
        static let licenseImageURL = "kLicenseImageURL"

    }
    
    //MARK:- Alert Messages
    struct AlertMessage{
        static let invalidEmail = "Please, provide a valid Email Id."
        static let passwordRange = "Password should be 6-25 characters long "
        static let emptyName = "Name text can not be left blank."
        static let emptyPreferredJobLocation = "Preferred Job Location can not be left blank."
        static let termsAndConditions = "Please accept terms and conditions/Privacy Policy."
        static let emptyCurrentJobTitle = "Current Job Title can not be left blank."
        static let emptyPassword = "Password can not be left blank."
        static let skipProfile = "Completed job profile will help you in applying for jobs."
        static let somethingWentWrong = "Something went wrong"
        
        static let emptyYearOfExperience = "Please select Year Of Experience."
        static let emptyOfficeName = "Office Name can not be left blank."
        static let emptyOfficeAddress = "Office Field can not be left blank."
        static let emptyCityName = "City Name can not be left blank."
        static let referenceMobileNumber = "Please, Provide a valid Phone number of 10 digits."
        
        struct AlertTitle {
            static let invalidEmailTitle = ""
        }
    }
    
    //MARK:- Strings
    struct Strings{
        static let whiteSpace = " "
    }
    
    //MARK:- Hardcoded Limits
    struct Limit{
        static let licenseNumberLimit = 16
        static let passwordLimit = 6
        static let maxPasswordLimit = 25
        static let commonMaxLimit = 30
        static let licenseNumber = 15

    }
}



