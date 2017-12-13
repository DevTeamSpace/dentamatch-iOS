//
//  DMEditProfileVC+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 18/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMEditProfileVC {
    
    func userProfileAPI(checkForCompletion:Bool = false) {
        if !checkForCompletion {
            self.showLoader()
        }
        APIManager.apiGet(serviceName: Constants.API.userProfile, parameters: [:]) { (response:JSON?, error:NSError?) in
            
            self.hideLoader()            
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            guard let _ = response else {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            debugPrint(response!)
            if checkForCompletion {
                self.handleUserResponse(user: response![Constants.ServerKey.result][Constants.ServerKey.user])
            } else {
                self.handleProfileResponse(response: response)
            }
            self.editProfileTableView.reloadData()
        }
    }
    
    func handleProfileResponse(response:JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                handleJobListResponse(jobLists: response[Constants.ServerKey.result][Constants.ServerKey.joblists].arrayValue)
                handleUserResponse(user: response[Constants.ServerKey.result][Constants.ServerKey.user])
                handleDentalStateboardResponse(dentalStateBoard: response[Constants.ServerKey.result][Constants.ServerKey.dentalStateBoard])
                handleLicenseResponse(license: response[Constants.ServerKey.result][Constants.ServerKey.license])
                handleCertificationResponse(certifications: response[Constants.ServerKey.result][Constants.ServerKey.certifications].arrayValue)
                handleAffiliationResponse(affiliations: response[Constants.ServerKey.result][Constants.ServerKey.affiliations].arrayValue)
                handleSchoolListResponse(schoolsCategories: response[Constants.ServerKey.result][Constants.ServerKey.school].arrayValue)
                handleSkillsResponse(skills: response[Constants.ServerKey.result][Constants.ServerKey.skills].arrayValue)
                handleWorkExperienceResponse(workExperienceArray: response[Constants.ServerKey.result][Constants.ServerKey.workExperience][Constants.ServerKey.list].arrayValue)
            } else {
                //handle error
            }
        }
    }
    
    func handleDentalStateboardResponse(dentalStateBoard:JSON?) {
        if let dentalStateBoard = dentalStateBoard {
            self.dentalStateBoardURL = dentalStateBoard[Constants.ServerKey.imageUrl].stringValue
        }
    }
    
    func handleJobListResponse(jobLists:[JSON]?) {
        if let jobLists = jobLists {
            for jobList in jobLists {
                let jobTitle = JobTitle(job: jobList)
                self.jobTitles.append(jobTitle)
            }
        }
    }
    
    func handleUserResponse(user:JSON?) {
        if let user = user {
            UserManager.shared().activeUser.firstName = user[Constants.ServerKey.firstName].stringValue
            UserManager.shared().activeUser.lastName = user[Constants.ServerKey.lastName].stringValue
            UserManager.shared().activeUser.jobTitle = user[Constants.ServerKey.jobtitleName].stringValue
            UserManager.shared().activeUser.jobTitleId = user[Constants.ServerKey.jobTitileId].stringValue
            UserManager.shared().activeUser.profileImageURL = user[Constants.ServerKey.profilePic].stringValue
            UserManager.shared().activeUser.preferredJobLocation = user[Constants.ServerKey.preferredLocationName].stringValue
            UserManager.shared().activeUser.preferredLocationId = user[Constants.ServerKey.preferredJobLocationId].stringValue
            UserManager.shared().activeUser.state = user[Constants.ServerKey.state].stringValue

            currentJobTitle = self.jobTitles.filter({$0.jobId == user[Constants.ServerKey.jobTitileId].intValue}).first

            UserManager.shared().activeUser.aboutMe = user[Constants.ServerKey.aboutMe].stringValue
            UserManager.shared().activeUser.licenseNumber = user[Constants.ServerKey.licenseNumber].stringValue
            self.isJobSeekerVerified = user["isJobSeekerVerified"].stringValue
            self.isProfileCompleted = user["isCompleted"].stringValue
            
            UserManager.shared().saveActiveUser()
            

        }
    }
    
    func handleLicenseResponse(license:JSON?) {
        if !(license?[Constants.ServerKey.licenseNumber].stringValue.isEmptyField)! {
            if let license = license {
                self.license = License(license: license)
            }
        }
    }
    
    func handleSchoolListResponse(schoolsCategories:[JSON]?) {
        if let schoolsCategories = schoolsCategories {
            for schoolCategory in schoolsCategories {
                let school = SelectedSchool(school: schoolCategory)
                self.schoolCategories.append(school)
            }
        }
    }
    
    func handleCertificationResponse(certifications:[JSON]?) {
        if let certifications = certifications {
            for certification in certifications {
                let certification = Certification(certification: certification)
                self.certifications.append(certification)
            }
        }
    }
    
    func handleAffiliationResponse(affiliations:[JSON]?) {
        if let affiliations = affiliations {
            for affiliation in affiliations {
                let affiliation = Affiliation(affiliation: affiliation)
                self.affiliations.append(affiliation)
            }
        }
    }
    
    func handleSkillsResponse(skills:[JSON]?) {
        if let skills = skills {
            for skillObj in skills {
                var subSkills = [SubSkill]()
                let subSkillsArray = skillObj["children"].arrayValue
                
                for subSkillObj in subSkillsArray {
                    let subSkill = SubSkill(subSkill: subSkillObj)
                     subSkills.append(subSkill)
                }
                
                let skill = Skill(skills: skillObj, subSkills: subSkills)
                self.skills.append(skill)
            }
            //otherSkill = skills.filter({$0.isOther == true}).first
            //skills = skills.filter({$0.isOther == false})
        }
    }
    
    func handleWorkExperienceResponse(workExperienceArray:[JSON]?) {
        if let workExperienceArray = workExperienceArray {
            for workExperience in workExperienceArray {
                let workExperience = ExperienceModel(json: workExperience)
                self.experiences.append(workExperience)
            }
        }
    }
}
