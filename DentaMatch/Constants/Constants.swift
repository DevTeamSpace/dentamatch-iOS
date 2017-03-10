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
        static let unSaveJobColor = UIColor.color(withHexCode: "6F6F6F")
        static let saveJobColor = UIColor.color(withHexCode: "0470c0")
        static let cancelJobDeleteColor = UIColor.color(withHexCode: "fe3824")
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
        static let availabilitySeletedColor = UIColor(red: 4.0/255.0, green: 112.0/255.0, blue: 192.0/255.0, alpha: 1.0)
        static let availabilityUnseletedColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        static let jobSearchUnSelectedLabel = UIColor(red: 181.0/255.0, green: 181.0/255.0, blue: 181.0/255.0, alpha: 1.0)
        static let jobSearchSelectedLabel = UIColor(red: 81.0/255.0, green: 81.0/255.0, blue: 81.0/255.0, alpha: 1.0)
        static let jobSearchTitleLocationColor = UIColor(colorLiteralRed: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        static let jobTitleLabelColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1.0)
        static let jobSkillBrickColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)
        static let mapButtonBackGroundColor = UIColor(red: 4/255.0, green: 112/255.0, blue: 191.0/255.0, alpha: 1.0)
        static let segmentViewBgColor = UIColor(red: 42/255.0, green: 85/255.0, blue: 169.0/255.0, alpha: 1.0)

        
        static let loaderRingColor = UIColor.color(withHexCode: "10193e")
        
        static let loaderBackgroundColor = UIColor.color(withHexCode: "959595")
        
        static let tickSelectColor = UIColor.init(red: 4.0/255.0, green: 112.0/255.0, blue: 192.0/255.0, alpha: 1.0)
        static let tickDeselectColor = UIColor.init(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        static let jobSearchBorderColor = UIColor.init(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        static let jobTitleBricksColor = UIColor.init(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1.0)
        static let jobTypeLabelDeselectedColor = UIColor.init(red: 181.0/255.0, green: 181.0/255.0, blue: 181.0/255.0, alpha: 1.0)
        static let partTimeDaySelectColor = UIColor.init(colorLiteralRed: 142.0/255.0, green: 207.0/255.0, blue: 125.0/255.0, alpha: 1.0)
        static let fullTimeBackgroundColor = UIColor.init(red: 69.0/255.0, green: 177.0/255.0 , blue: 179.0/255.0, alpha: 1.0)
        static let temporaryBackGroundColor = UIColor.color(withHexCode: "f1b85a")
        static let segmentControlBorderColor = UIColor.init(red: 42/255.0, green: 85/255.0, blue: 169.0/255.0, alpha: 1.0)
        static let segmentControlSelectionColor = UIColor.init(red: 4/255.0, green: 112/255.0, blue: 191.0/255.0, alpha: 1.0)
        static let partTimeEventColor = UIColor.init(red: 142.0/255.0, green: 207.0/255.0, blue: 126.0/255.0, alpha: 1)
        static let tempTimeEventColor = UIColor.init(red: 241.0/255.0, green: 184.0/255.0, blue: 90.0/255.0, alpha: 1)
        
        static let notificationUnreadTextColor = UIColor.init(red: 15.0/255.0, green: 24.0/255.0, blue: 62.0/255.0, alpha: 1)
        static let notificationUnreadTimeLabelColor = UIColor.init(red: 15.0/255.0, green: 24.0/255.0, blue: 62.0/255.0, alpha: 1)
        static let notificationreadTextColor = UIColor.init(red: 71.0/255.0, green: 71.0/255.0, blue: 71.0/255.0, alpha: 1)
        static let notificationreadTimeLabelColor = UIColor.init(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1)


    }
    
    struct DesignFont {
        static let acceptTermsSelected = "w"
        static let acceptTermsDeSelected = "t"
        static let notification = "a"
        static let search = "y"
        static let notFavourite = "r"
        static let favourite = "z"
        static let about = "i"
        static let jobDescription = "g"
        static let officeDescription = "v"
        static let map = "j"
    }
    
    //MARK:- StoryBoards
    struct StoryBoard {
        static let onBoardingStoryboard  = "Onboarding"
        static let registrationStoryboard  = "Registration"
        static let profileStoryboard  = "Profile"
        static let jobSearchStoryboard  = "JobSearch"
        static let trackStoryboard  = "Track"
        static let dashboardStoryboard  = "Dashboard"
        static let messagesStoryboard  = "Messages"
        static let calenderStoryboard  = "Calender"
        static let notificationStoryboard  = "Notification"

        
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
        static let updateDeviceToken = Constants.API.apiURL("users/update-devicetoken")
        static let licenseNumberAndState = Constants.API.apiURL("users/update-license")
        static let workExperienceSave = Constants.API.apiURL("users/work-experience-save")
        static let getWorkExperience = Constants.API.apiURL("users/work-experience-list")
        static let deleteExperience = Constants.API.apiURL("users/work-experience-delete")
        static let updateCertificate = Constants.API.apiURL("users/update-certificate")
        static let updateValidationDates = Constants.API.apiURL("users/update-certificate-validity")
        static let changePassword = Constants.API.apiURL("users/change-password")
        static let updateHomeLocation = Constants.API.apiURL("users/user-location-update")
        static let userProfile = Constants.API.apiURL("users/user-profile")
        static let signOut = Constants.API.apiURL("users/sign-out")
        static let jobList = Constants.API.apiURL("users/job-list")
        static let saveJob = Constants.API.apiURL("users/save-job")
        static let cancelJob = Constants.API.apiURL("users/cancel-job")
        static let jobDetail = Constants.API.apiURL("jobs/job-detail")
        static let applyJob = Constants.API.apiURL("users/apply-job")

        
        static let getNotificationList = Constants.API.apiURL("users/notification-list")
        static let readNotification = Constants.API.apiURL("users/notification-read")
        static let acceptRejectNotification = Constants.API.apiURL("users/acceptreject-job")
        static let deleteNotification = Constants.API.apiURL("users/delete-notification")
        static let unreadNotificationCount = Constants.API.apiURL("users/unread-notification")

        
        static let setAvailabality = Constants.API.apiURL("users/update-availability")
        static let getAvailabality = Constants.API.apiURL("users/availability-list")
        static let getHiredJobs = Constants.API.apiURL("jobs/hired-jobs")
        static let getChatUserList = Constants.API.apiURL("users/chat-user-list")
        static let blockUnblockRecruiter = Constants.API.apiURL("users/chat-user-block-unblock")

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
        static let zipcode = "zipcode"
        static let userType = "userType"
        static let status = "status"
        static let statusCode = "statusCode"
        static let message = "message"
        static let licenseNumber = "licenseNumber"
        static let state = "state"
        static let userDetails = "userDetails"
        static let searchFilters = "searchFilters"
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
        static let cancelReason = "cancelReason"

        static let imageURL = "imagePath"
        static let imageURLForPostResponse = "imgUrl"

        static let experienceId = "id"
        static let userId = "userId"
        static let user = "user"
        static let jobId = "jobId"
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
        static let schoolTitle = "schoolTitle"

        static let yearOfGraduation = "yearOfGraduation"
        static let jobSeekerStatus = "jobSeekerStatus"
        static let recruiterId = "recruiterId"
        static let blockStatus = "blockStatus"
        
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
        static let jobTitles = "jobTitles"
        static let page = "page"
        static let isFulltime = "isFulltime"
        static let isParttime = "isParttime"
        static let parttimeDays = "parttimeDays"
        static let address = "address"
        static let city = "city"
        static let state = "state"
        static let country = "country"
    }
    
    //MARK:- UserDefault Keys
    struct UserDefaultsKey {
        static let isLoggedIn = "isLoggedIn"
        static let deviceToken = "kDeviceToken"
        static let isProfileSkipped = "kIsProfileSkipped"
        static let isOnBoardingDone = "kIsOnBoardingDone"
        static let isHistoryRetrieved = "kIsHistoryRetrieved"
        static let isLoggedOut = "kIsLoggedOut"
        static let isProfileCompleted = "kIsProfileCompleted"
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
        static let emptyCancelReason = "Please enter the reason for cancellation"
        static let emptyJobTitle = "Please select a Job title"
        static let emptyPinCode = "Pincode not found. Please select some other location"

        static let emptyPreferredJobLocation = "Preferred Job Location can not be left blank."
        //license no screen
        static let emptyLicenseNumber = "Please enter License number"
        static let emptyState = "Please enter State"
        static let stateCertificate = "Please upload photo for Dental state board"
        static let lienseNoStartError = "License number can't start with hyphen (-)"
        static let stateStartError = "State  can't start with hyphen (-)"
        
        static let termsAndConditions = "Please accept terms and conditions/Privacy Policy."
        static let emptyCurrentJobTitle = "Current Job Title can not be left blank."
        static let emptyPassword = "Please enter the password"
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
        static let empptyFirstReference = "Please complete the reference"

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
        
        //Apply Job
        static let congratulations = "Congratulations"
        static let jobApplied = "You have successfully applied for the job."
        static let completeYourProfile = "Complete your profile"
        static let completeYourProfileDetailMsg = "You’ll need to fill out your profile before applying for the job. Would you like to fill this out now?"
        
        //Calendar Screen 
        static let canNotSelectPreDate = "Sorry you can't select previouse date"
        static let socketNotConnected = "Unable to connect to server. Please try again later"

        
        //Notification Screen 
        static let noNotification = "You don’t have any Notifications right now."
        
        
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
        static let jobSearch = "SEARCH JOBS"
        static let jobTitle = "JOB TITLE"
        static let jobDetails = "JOB DETAILS"
        static let notification = "NOTIFICATIONS"

    }
    
    //MARK:- Strings
    struct Strings{
        static let whiteSpace = " "
        static let resultsFound = "results found"
        static let save = "Save"
        static let today = "Today"
        static let daysAgo = "DAYS AGO"
        static let dayAgo = "DAY AGO"
        static let comma = ","
        static let miles = "miles"
        static let partTime = "Part Time"
        static let fullTime = "Full Time"
        static let zero = "0"
        static let one = "1"
        static let yes = "Yes"
        static let no = "No"
        static let about = "ABOUT"
        static let jobDesc = "JOB DESCRIPTION"
        static let officeDesc = "OFFICE DESCRIPTION"
        static let map = "MAP"
        static let readMore = "READ MORE"
        static let readLess = "READ LESS"
        static let appliedForThisJob = "APPLIED FOR THIS JOB"
        static let applyForJob = "APPLY FOR JOB"
    }
    
    //MARK:- Weak Days
    struct DaysAbbreviation{
        static let sunday = "Su"
        static let monday = "Mo"
        static let tuesday = "Tu"
        static let wednesday = "We"
        static let thursday = "Th"
        static let friday = "Fr"
        static let saturday = "Sa"
    }
    
    //MARK:- Weak Days
    struct Days{
        static let sunday = "sunday"
        static let monday = "monday"
        static let tuesday = "tuesday"
        static let wednesday = "wednesday"
        static let thursday = "thursday"
        static let friday = "friday"
        static let saturday = "saturday"
    }
    
    //MARK:- Hardcoded Limits
    struct Limit{
        static let licenseNumberLimit = 16
        static let passwordLimit = 6
        static let maxPasswordLimit = 25
        static let commonMaxLimit = 30
        static let licenseNumber = 15
        static let aboutMeLimit = 500

    }
}
