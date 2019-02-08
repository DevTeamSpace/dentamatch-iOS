import Foundation
import SwiftyJSON

class DMEditSkillsPresenter: DMEditSkillsPresenterProtocol {
    
    unowned let viewInput: DMEditSkillsViewInput
    unowned let moduleOutput: DMEditSkillsModuleOutput
    
    var skills = [Skill]()
    
    init(skills: [Skill]?, viewInput: DMEditSkillsViewInput, moduleOutput: DMEditSkillsModuleOutput) {
        self.selectedSkills = skills ?? []
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
    
    var otherSkill: Skill?
    var selectedSkills = [Skill]()
}

extension DMEditSkillsPresenter: DMEditSkillsModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMEditSkillsPresenter: DMEditSkillsViewOutput {
    
    func getSkillList() {
        
        viewInput.showLoading()
        APIManager.apiGet(serviceName: Constants.API.getSkillList, parameters: [:]) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            if response[Constants.ServerKey.status].boolValue {
                let skillList = response[Constants.ServerKey.result][Constants.ServerKey.skillList].arrayValue
                self?.prepareSkillData(skillList: skillList)
                self?.viewInput.reloadData()
            } else {
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
    
    func onSaveButtonTap() {
        let params = prepareSkillUpdateData()
        guard let others = params["other"] as? [[String: AnyObject]], let skills = params["skills"] as? [String] else { return }
        
        if skills.count > 0 {
            updateSkills(params: params)
        } else {
            
            if others.count > 1 {
                updateSkills(params: params)
            } else if others.count == 1 {
                if otherSkill?.otherText == "" {
                    viewInput.show(toastMessage: "Please select atleast one skill")
                } else {
                    updateSkills(params: params)
                }
            } else if others.count == 0 {
                viewInput.show(toastMessage: "Please select atleast one skill")
            }
        }
    }
    
    func updateSkills(params: [String: AnyObject]) {
        
        viewInput.showLoading()
        APIManager.apiPostWithJSONEncode(serviceName: Constants.API.updateSkillList, parameters: params) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            if response[Constants.ServerKey.status].boolValue {
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
                self?.updateProfileScreen()
                self?.viewInput.popViewController()
            }
        }
    }
}

extension DMEditSkillsPresenter {
    
    private func prepareSkillData(skillList: [JSON]) {
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
        
        otherSkill = skills.filter({ $0.isOther == true }).first
        skills = skills.filter({ $0.isOther == false })
    }
    
    private func prepareSkillUpdateData() -> [String: AnyObject] {
        var params = [
            "other": [] as AnyObject,
            "skills": [] as AnyObject,
            ]
        
        var skillsId = [String]()
        var others = [[String: AnyObject]]()
        
        for skill in skills {
            let subSkills = skill.subSkills.filter({ $0.isSelected == true })
            for subSkill in subSkills {
                if subSkill.isOther {
                    var otherSubSkill = [String: String]()
                    otherSubSkill["id"] = subSkill.subSkillId
                    otherSubSkill["value"] = subSkill.otherText
                    others.append(otherSubSkill as [String: AnyObject])
                } else {
                    skillsId.append(subSkill.subSkillId)
                }
            }
        }
        
        if let _ = otherSkill {
            var other = [String: String]()
            other["id"] = otherSkill?.skillId
            other["value"] = otherSkill?.otherText
            if !(otherSkill?.otherText.isEmptyField)! {
                others.append(other as [String: AnyObject])
            }
        }
        params["skills"] = skillsId as AnyObject?
        params["other"] = others as AnyObject?
        return params
    }
    
    private func updateProfileScreen() {
        selectedSkills.removeAll()
        for skillObj in skills {
            let selectedSubSkills = skillObj.subSkills.filter({ $0.isSelected == true })
            if selectedSubSkills.count > 0 {
                let skill = Skill()
                skill.skillId = skillObj.skillId
                skill.skillName = skillObj.skillName
                skill.subSkills = selectedSubSkills
                skill.isOther = skillObj.isOther
                skill.otherText = skillObj.otherText
                selectedSkills.append(skill)
            }
        }
        
        if let otherSkill = otherSkill {
            let skill = Skill()
            skill.skillId = otherSkill.skillId
            skill.skillName = otherSkill.skillName
            let subSkill = SubSkill()
            subSkill.subSkillName = otherSkill.otherText
            skill.subSkills = [subSkill]
            skill.isOther = otherSkill.isOther
            skill.otherText = otherSkill.otherText
            if !skill.otherText.isEmptyField {
                selectedSkills.append(skill)
            }
        }
        
        NotificationCenter.default.post(name: .updateProfileScreen, object: nil, userInfo: ["skills": self.selectedSkills])
    }
}
