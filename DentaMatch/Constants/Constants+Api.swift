//
//  Constants+Api.swift
//  DentaMatch
//
//  Created by Prashant Gautam on 09/07/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import Foundation

extension Constants { 
    
    // MARK: - API Urls
    
    struct API {
        // APIs
        static let registration = Constants.API.apiURL("users/sign-up")
        static let login = Constants.API.apiURL("users/sign-in")
        static let forgotPassword = Constants.API.apiURL("users/forgot-password")
        static let termsAndConditionsURL = Constants.API.apiURL("term-condition")
        static let emailVerify = Constants.API.apiURL("users/is-verified")
        static let privacyPolicyURL = Constants.API.apiURL("privacy-policy")
        static let getPreferredJobLocations = Constants.API.apiURL("jobs/preferred-job-locations")
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
        static let chatDelete = Constants.API.apiURL("chat/delete")
        
        static func apiURL(_ methodName: String) -> String {
            return BASE_URL + methodName
        }
    }

    
    
}
