//
//  Constants+AlertMessage.swift
//  DentaMatch
//
//  Created by Prashant Gautam on 09/07/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import Foundation
// swiftlint:disable nesting
extension Constants {

    // MARK: - Alert Messages
    
    struct AlertMessage {
        static let emptyEmail = "Email Id can not be left blank."
        static let invalidEmail = "Please provide a valid Email Id."
        static let invalidEmailAddress = "Please provide a valid email address."
        static let passwordRange = "Password should be 6-25 characters long."
        static let emptyName = "Name text can not be left blank."
        static let emptyFirstName = "First Name text can not be left blank."
        static let emptyLastName = "Last Name text can not be left blank."
        static let emptyAboutMe = "About Me text can not be left blank."
        static let emptyValidityDate = "Please enter the validity date"
        static let emptyCancelReason = "Please enter the reason for the cancellation"
        static let emptyJobTitle = "Please select a Job title"
        static let emptyPinCode = "Pincode not found. Please select some other location"
        
        static let emptyPreferredJobLocation = "Looking for Jobs In can not be left blank."
        // license no screen
        static let emptyLicenseNumber = "Please enter License number"
        static let emptyState = "Please enter License state"
        static let stateCertificate = "Please upload photo for Dental state board"
        static let lienseNoStartError = "License number can't start with hyphen (-)"
        static let stateStartError = "State  can't start with hyphen (-)"
        
        static let termsAndConditions = "Please accept Terms and Conditions/Privacy Policy."
        static let emptyCurrentJobTitle = "Current Job Title can not be left blank."
        static let emptyPassword = "Password can not be left blank."
        static let skipProfile = "Completing your profile will help you stand out to potential Employers."
        static let somethingWentWrong = "Something went wrong."
        
        // Experience
        static let emptyYearOfExperience = "Please select experience."
        static let emptyOfficeName = "Office Name can not be left blank."
        static let emptyOfficeAddress = "Office Field can not be left blank."
        static let emptyCityName = "City Name can not be left blank."
        static let emptyStateName = "State Name can not be left blank."
        static let referenceMobileNumber = "Please, Provide a valid Phone number of 10 digits."
        static let atleastOneExperience = "Please add at least one experience"
        static let partialFill = "You have partially filled experience. Do you want to Discard this?"
        static let firstEmptyExperience = "Please add Reference 1 first."
        
        static let morethen2refernce = "More than two references can not be added."
        static let empptyFirstReference = "Please complete the reference"
        
        static let emptyOldPassword = "Old password can never be blank."
        static let emptyNewPassword = "New password can never be blank."
        static let emptyConfirmPassword = "Confirm password can never be blank."
        static let matchPassword = "New password and Confirm password should be same."
        
        // setAvailability
        static let selectAvailableDay = "Please select at least one day"
        static let selectDate = "Please select at least date"
        static let selectOneAvailableOption = "Please select at least one Avaialbe Option"
        
        // Job Search
        static let selectTitle = "Please select at least one title"
        static let selectPreferredLocation = "Please select at least one location"
        
        static let selectLocation = "Please select location"
        
        // Apply Job
        static let congratulations = "Congratulations"
        static let niceToMeetYou = "Nice to Meet You"
        static let jobApplied = "You have successfully applied for the job."
        static let jobAccepted = "You have successfully accept this job."
        static let completeYourProfile = "Complete your profile"
        static let completeYourProfileDetailMsg = "You’ll need to filling out your profile before applying for the job. Would you like to fill this out now?"
        
        // Calendar Screen
        static let canNotSelectPreDate = "Sorry you can't select previous date"
        static let socketNotConnected = "Unable to connect to server. Please try again later"
        
        // Notification Screen
        static let noNotification = "You don’t have any Notifications right now."
        
        // change password screen messgaes
        struct AlertTitle {
            static let invalidEmailTitle = ""
        }
    }

}
// swiftlint:enable nesting
