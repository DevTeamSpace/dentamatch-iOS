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
    
    func userProfileAPI() {
        self.showLoader()
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
            self.handleProfileResponse(response: response)
            self.editProfileTableView.reloadData()
        }
    }
    
    func handleProfileResponse(response:JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                handleUserResponse(user: response[Constants.ServerKey.result][Constants.ServerKey.user])
                handleLicenseResponse(license: response[Constants.ServerKey.result][Constants.ServerKey.license])
                handleCertificationResponse(certifications: response[Constants.ServerKey.result][Constants.ServerKey.certifications].arrayValue)
                handleAffiliationResponse(affiliations: response[Constants.ServerKey.result][Constants.ServerKey.affiliations].arrayValue)
                handleSkillsResponse(skills: response[Constants.ServerKey.result][Constants.ServerKey.skills].arrayValue)
            } else {
                //handle error
            }
        }
    }
    
    func handleUserResponse(user:JSON?) {
        if let user = user {
            UserManager.shared().activeUser.firstName = user[Constants.ServerKey.firstName].stringValue
            UserManager.shared().activeUser.lastName = user[Constants.ServerKey.lastName].stringValue
            UserManager.shared().activeUser.profileImageURL = user[Constants.ServerKey.profilePic].stringValue
        }
    }
    
    func handleLicenseResponse(license:JSON?) {
        if let license = license {
            self.license = License(license: license)
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
                self.affliations.append(affiliation)
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
}
