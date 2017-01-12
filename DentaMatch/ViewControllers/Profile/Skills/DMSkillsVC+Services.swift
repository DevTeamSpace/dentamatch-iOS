//
//  DMSkills+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMSkillsVC {
    
    func getSkillListAPI() {
        self.showLoader()
        APIManager.apiGet(serviceName: Constants.API.getSkillList, parameters: [:]) { (response:JSON?, error:NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            
            if response == nil {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            print(response!)
            self.handleSkillListResponse(response: response)
        }
    }
    
    func handleSkillListResponse(response:JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                let skillList = response[Constants.ServerKey.result][Constants.ServerKey.skillList].arrayValue
                prepareSkillData(skillList: skillList)
                self.skillsTableView.reloadData()
            } else {
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
    
    func prepareSkillData(skillList:[JSON]) {
        for skillObj in skillList {
            
            var subSkills = [SubSkill]()
            let subSkillsArray = skillObj["children"].arrayValue
            
            for subSkillObj in subSkillsArray {
                let subSkill = SubSkill(subSkill: subSkillObj)
                subSkills.append(subSkill)
            }
            
            let skill = Skill(skills: skillObj, subSkills: subSkills)
            skills.append(skill)
        }
    }
}
