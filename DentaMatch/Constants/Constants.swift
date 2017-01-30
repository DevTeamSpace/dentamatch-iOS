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
let kCertificatePlaceHolder = UIImage(named: "certificatePlaceholder")


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
        static let brickTextColor =  UIColor.color(withHexCode: "959595")

        static let textFieldErrorColor = UIColor.color(withHexCode: "ff0000")
        
        static let profileProgressBarColor = UIColor.color(withHexCode: "a3d977")
        static let profileProgressBarTrackColor = UIColor.color(withHexCode: "f4f4f4")
        
        static let navBarColor = UIColor.color(withHexCode: "10193e")
        static let navBarColorForExperienceScreen = UIColor.color(withHexCode: "f7f7f7")
        static let navHeadingForExperienceScreen = UIColor(red: 9.0/255.0, green: 41.0/255.0, blue: 97.0/255.0, alpha: 1)
        
         static let headerTitleColor = UIColor(red: 81.0/255.0, green: 81.0/255.0, blue: 81.0/255.0, alpha: 1)
        static let weekdayTextColor = UIColor(red: 81.0/255.0, green: 81.0/255.0, blue: 81.0/255.0, alpha: 0.5)
        
        static let selectionColor = UIColor(red: 241.0/255.0, green: 184.0/255.0, blue: 90.0/255.0, alpha: 1)
        
        static let CalendarSelectionColor = UIColor(red: 15.0/255.0, green: 24.0/255.0, blue: 62.0/255.0, alpha: 1)
        
        //static let

        static let loaderRingColor = UIColor.color(withHexCode: "10193e")
        static let loaderBackgroundColor = UIColor.color(withHexCode: "959595")
        
        

    }
    
    struct DesignFont {
        static let acceptTermsSelected  = "w"
        static let acceptTermsDeSelected  = "t"
        static let notification  = "a"
        static let search  = "y"
    }
    
    //MARK:- StoryBoards
    struct StoryBoard {
        static let onBoardingStoryboard  = "Onboarding"

        static let registrationStoryboard  = "Registration"
        static let profileStoryboard  = "Profile"
        static let jobSearchStoryboard  = "JobSearch"
 
        static let dashboardStoryboard  = "Dashboard"
        static let calenderStoryboard  = "Calender"


        struct Identifer {
            static let registrationNav = "RegistrationNAV"
            static let profileNav  = "ProfileNAV"
            static let jobSearchNav  = "JobSearchNav"
            static let editProfileNav  = "EditProfileNAV"
        }
        
        struct SegueIdentifier {
            static let goToStudyVC = "goToStudyVC"
            static let goToSkillsVC = "goToSkillsVC"
            static let goToPublicProfile = "goToPublicProfile"
            static let goToAffiliationsVC = "goToAffiliationsVC"
            static let goToCertificationsVC = "goToCertificationsVC"
            static let goToExecutiveSummaryVC = "goToExecutiveSummaryVC"
            static let goToLicense = "goToLicense"
            static let goToEditLicense = "goToEditLicense"
            static let goToSetting = "goToSetting"
            static let goToChangePassword = "goToChangePassword"
            static let goToEditCertificate = "goToEditCertificate"

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
        static let JobSearchResultAPI = Constants.API.apiURL("users/search-jobs")
        static let updateUserProfile = Constants.API.apiURL("users/user-profile-update")
        
        static let licenseNumberAndState = Constants.API.apiURL("users/update-license")
        static let workExperienceSave = Constants.API.apiURL("users/work-experience-save")
        static let getWorkExperience = Constants.API.apiURL("users/work-experience-list")
        static let deleteExperience = Constants.API.apiURL("users/work-experience-delete")
        static let updateCertificate = Constants.API.apiURL("users/update-certificate")
        static let updateValidationDates = Constants.API.apiURL("users/update-certificate-validity")
        static let changePassword = Constants.API.apiURL("users/change-password")
        static let userProfile = Constants.API.apiURL("users/user-profile")
        static let signOut = Constants.API.apiURL("users/sign-out")
        static let jobList = Constants.API.apiURL("users/job-list")
        static let setAvailabality = Constants.API.apiURL("users/update-availability")

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
        static let preferredJobLocation = "preferredJobLocation"
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
        static let dentalStateBoard = "dentalStateBoard"
        static let accessToken = "accessToken"
        static let joblists = "joblists"
        static let joblist = "list"
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
        static let license = "licence"
        static let certifications = "certifications"
        static let affiliations = "affiliations"
        static let skills = "skills"

        static let imageURL = "imagePath"
        static let imageURLForPostResponse = "imgUrl"

        static let experienceId = "id"
        static let userId = "userId"
        static let user = "user"
        static let jobTitleId = "jobTitleId"
        static let jobTitileId = "jobTitileId"
        static let jobTitle = "jobTitle"
        static let jobtitleName = "jobtitleName"
        static let monthsOfExperience = "monthsOfExpereince"
        static let officeName = "officeName"
        static let officeAddressExp = "officeAddress"
        static let cityName = "city"
        static let workExperience = "workExperience"

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
        static let childId = "childId"
        static let isSkillSelected = "userSkill"
        
        static let certificateName = "certificateName"
        static let schoolingId = "schoolingId"
        static let schoolingChildId = "schoolingChildId"
        static let schoolName = "schoolName"
        static let school = "school"
        static let schoolCategory = "schoolCategory"
        static let otherSchooling = "otherSchooling"
        static let schoolChildName = "schoolChildName"
        static let yearOfGraduation = "yearOfGraduation"
        static let jobSeekerStatus = "jobSeekerStatus"
        
        //change password screen
        static let oldPass = "oldPassword"
        static let newPass = "newPassword"
        static let confirmPass = "confirmNewPassword"

    }
    
    struct JobDetailKey {
        static let lat = "lat"
        static let lng = "lng"
        static let zipCode = "zipCode"
        static let jobTitle = "jobTitle"
        static let page = "page"
        static let isFulltime = "isFulltime"
        static let isParttime = "isParttime"
        static let parttimeDays = "parttimeDays"
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
        static let invalidEmail = "Please provide a valid Email Id."
        static let passwordRange = "Password should be 6-25 characters long"
        static let emptyName = "Name text can not be left blank."
        static let emptyFirstName = "First Name text can not be left blank."
        static let emptyLastName = "Last Name text can not be left blank."
        static let emptyAboutMe = "About Me text can not be left blank."
        static let emptyValidityDate = "Please enter the validity date"

        static let emptyPreferredJobLocation = "Preferred Job Location can not be left blank."
        //license no screen
        static let emptyLicenseNumber = "Please enter License number"
        static let emptyState = "Please enter State"
        static let stateCertificate = "Please upload photo for Dental state board"
        static let lienseNoStartError = "License number can't start with hyphen (-)"
        static let stateStartError = "State  can't start with hyphen (-)"
        
        static let termsAndConditions = "Please accept terms and conditions/Privacy Policy."
        static let emptyCurrentJobTitle = "Current Job Title can not be left blank."
        static let emptyPassword = "please enter the password"
        static let skipProfile = "Completed job profile will help you in applying for jobs."
        static let somethingWentWrong = "Something went wrong"
        
        //Experience
        static let emptyYearOfExperience = "Please select Year Of Experience."
        static let emptyOfficeName = "Office Name can not be left blank."
        static let emptyOfficeAddress = "Office Field can not be left blank."
        static let emptyCityName = "City Name can not be left blank."
        static let referenceMobileNumber = "Please, Provide a valid Phone number of 10 digits."
        static let atleastOneExperience  = "Please add at least one experience"
        static let partialFill  = "You have partially filled experience. Do you want to Discard this?"

        static let morethen2refernce = "More than two references can not be added."
        
        static let emptyOldPassword = "Please enter Old password"
        static let emptyNewPassword = "Please enter New password"
        static let emptyConfirmPassword = "Please enter Confirm password"
        static let matchPassword = "New password and Confirm password not match"
        
        //setAvailability
        static let selectAvailableDay = "Please select at least one day"
        static let selectDate = "Please select at least date"
        static let selectOneAvailableOption = "Please select at least one Avaialbe Option"
        
        //Job Search
        static let selectTitle = "Please select at least one title"
        static let selectLocation = "Please select location"
        
        //change password screen messgaes
        struct AlertTitle {
            static let invalidEmailTitle = ""
        }
    }
    
    struct ScreenTitleNames{
        static let calendar = "Calendar"
        static let resetPassword = "Reset Password"
        static let setAvailibility = "SET AVAILABILITY"
        static let settings = "SETTINGS"
        static let workExperience = "Work Experience"
        static let forgotPassword = "FORGOT PASSWORD"
        static let jobSearch = "SEARCH JOB"
        static let jobTitle = "JOB TITLE"
        static let jobDetail = "JOB DETAIL"
    }
    
    //MARK:- Strings
    struct Strings{
        static let whiteSpace = " "
        static let resultsFound = "results found"
        static let save = "Save"
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
