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
            debugPrint(response!)
            self.handleSkillListResponse(response: response)
        }
    }
    
    func updateSkillsAPI(params:[String:AnyObject]) {
        debugPrint("Update Skill params \(params)")
        self.showLoader()
        APIManager.apiPostWithJSONEncode(serviceName: Constants.API.updateSkillList, parameters: params) { (response:JSON?, error:NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            
            if response == nil {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            debugPrint(response!)
            self.handleUpdateSkillsResponse(response: response)
        }
    }
    
    //MARK:- Response Handling
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
    
    func handleUpdateSkillsResponse(response:JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
                openAffiliationScreen()
            } else {
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
        
        otherSkill = skills.filter({$0.isOther == true}).first
        skills = skills.filter({$0.isOther == false})
    }
    
    func prepareSkillUpdateData() -> [String:AnyObject] {
        var params = [
            "other":[] as AnyObject,
            "skills":[] as AnyObject
            ]
        
        var skillsId = [String]()
        var others = [[String:AnyObject]]()

        for skill in skills {
            let subSkills = skill.subSkills.filter({$0.isSelected == true})
            for subSkill in subSkills {
                if subSkill.isOther {
                    var otherSubSkill = [String:String]()
                    otherSubSkill["id"] = subSkill.subSkillId
                    otherSubSkill["value"] = subSkill.otherText
                    others.append(otherSubSkill as [String : AnyObject])
                } else {
                skillsId.append(subSkill.subSkillId)
                }
            }
        }
        
        if let _ = otherSkill {
            var other = [String:String]()
            other["id"] = otherSkill?.skillId
            other["value"] = otherSkill?.otherText
            if !(otherSkill?.otherText.isEmptyField)! {
                others.append(other as [String : AnyObject])
            }
        }
        params["skills"] = skillsId as AnyObject?
        params["other"] = others as AnyObject?
        return params
    }
}
