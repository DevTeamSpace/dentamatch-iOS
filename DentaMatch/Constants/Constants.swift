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
let kAppDelegate = UIApplication.shared.delegate as? AppDelegate
let kDeviceId = "com.appster.dentamatch.deviceId"
let kCustomDesignFont = "dentamatch"
let kLogEnabled = true
let kPlaceHolderImage = UIImage(named: "profileButton")
let kCertificatePlaceHolder = UIImage(named: "certificatePlaceholder")

let kGoogleAPIKey = "AIzaSyD1xD10kM-xCzRswPNEoovElT2vhpJQSGo" // "AIzaSyDFWCamiO9WGTth-iOxfY_L0K6oRBeAu0U"

let kOkButtonTitle = "Ok"
let kOpenGoogleMapUrl = "comgooglemaps://"
let kGoogleSearchMap = "https://maps.google.com/?q="
let kInstaBugKey = "AIzaSyD1xD10kM-xCzRswPNEoovElT2vhpJQSGo"

// swiftlint:disable nesting
struct Constants {
    static let BASE_URL = Constants.apiBaseURL()
    static let kUnreadCount = "UnreadNotificationCount"
    static let kEmptyDate = "0000-00-00"
    static func apiBaseURL() -> String {
        return ConfigurationManager.sharedManager().applicationEndPoint()
    }

    struct Heading {
        static let heading1 = "You Work Hard Enough"
        static let heading2 = "Apply Away"
        static let heading3 = "Set Your Schedule"
        static let heading4 = "Build Your Profile"
    }

    struct SubHeading {
        static let subHeading1 = "DentaMatch makes it easy to pick up an extra day, find a  part-time gig, or a new full-time position. "
        static let subHeading2 = "Search and apply to job matches, star your favorites, and accept temp work from offices directly."
        static let subHeading3 = "Select the type of work you’re looking for and the days you’re available to temp. You can update it anytime."
        static let subHeading4 = "Who Need a resume? Just add your skills and certifications to your profile and we’ll do the matching."
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

    // MARK: - StoryBoards
    struct StoryBoard {
        static let onBoardingStoryboard = "Onboarding"
        static let registrationStoryboard = "Registration"
        static let profileStoryboard = "Profile"
        static let jobSearchStoryboard = "JobSearch"
        static let trackStoryboard = "Track"
        static let dashboardStoryboard = "Dashboard"
        static let messagesStoryboard = "Messages"
        static let calenderStoryboard = "Calender"
        static let notificationStoryboard = "Notification"
        static let states = "States"
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
        static let preferredJobLocationId = "preferredJobLocationId"
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
        static let stateName = "state"
        static let workExperience = "workExperience"
        static let preferredLocationName = "preferredLocationName"
        static let isActive = "isActive"

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

        // change password screen
        static let oldPass = "oldPassword"
        static let newPass = "newPassword"
        static let confirmPass = "confirmNewPassword"
        //
        static let statelist = "stateList"
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

    // MARK: - UserDefault Keys

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

    

    struct ScreenTitleNames {
        static let calendar = "Calendar"
        static let resetPassword = "Reset Password"
        static let setAvailibility = "SET AVAILABILITY"
        static let settings = "SETTINGS"
        static let workExperience = "EMPLOYMENT HISTORY"
        static let forgotPassword = "FORGOT PASSWORD"
        static let jobSearch = "FILTER JOBS"
        static let jobTitle = "JOB TITLE"
        static let jobDetails = "JOB DETAILS"
        static let notification = "NOTIFICATIONS"
    }

    // MARK: - Strings
    struct Strings {
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
        static let workingHours = "WORKING HOURS"
    }

    // MARK: - Weak Days
    struct DaysAbbreviation {
        static let sunday = "Su"
        static let monday = "Mo"
        static let tuesday = "Tu"
        static let wednesday = "We"
        static let thursday = "Th"
        static let friday = "Fr"
        static let saturday = "Sa"
    }

    // MARK: - Weak Days
    struct Days {
        static let sunday = "sunday"
        static let monday = "monday"
        static let tuesday = "tuesday"
        static let wednesday = "wednesday"
        static let thursday = "thursday"
        static let friday = "friday"
        static let saturday = "saturday"
    }

    // MARK: - Hardcoded Limits
    struct Limit {
        static let licenseNumberLimit = 16
        static let passwordLimit = 6
        static let maxPasswordLimit = 25
        static let commonMaxLimit = 30
        static let licenseNumber = 15
        static let aboutMeLimit = 500
    }
}
// swiftlint:enable nesting
