import Foundation
import SwiftyJSON

class DMSelectSkillsPresenter: DMSelectSkillsPresenterProtocol {
    
    unowned let viewInput: DMSelectSkillsViewInput
    unowned let moduleOutput: DMSelectSkillsModuleOutput
    
    init(viewInput: DMSelectSkillsViewInput, moduleOutput: DMSelectSkillsModuleOutput) {
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
    
    var skill: Skill?
    var subSkills = [SubSkill]()
    var subSkillWithoutOther = [SubSkill]()
    var otherSkill: SubSkill?
    var otherText = ""
}

extension DMSelectSkillsPresenter: DMSelectSkillsModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMSelectSkillsPresenter: DMSelectSkillsViewOutput {
    
    func didLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(getSubSkillData), name: NSNotification.Name(rawValue: "getSubSkillData"), object: nil)
    }
    
    func willAppear() {
        guard let skill = skill else { return }
        
        subSkills.removeAll()
        subSkills = skill.subSkills
        
        subSkillWithoutOther = subSkills.filter({ $0.isOther == false })
        otherSkill = subSkills.filter({ $0.isOther == true }).first
        subSkills = subSkillWithoutOther
        
        if let _ = otherSkill {
            subSkills.append(otherSkill!)
            otherText = (otherSkill?.otherText)!
            if otherText.isEmptyField {
                otherSkill?.isSelected = false
                otherSkill?.otherText = ""
            }
        }
        
        viewInput.reloadData()
    }
}

extension DMSelectSkillsPresenter {
    
    @objc private  func getSubSkillData(info: Notification) {
        guard let userInfo = info.userInfo, let skill = userInfo["skill"] as? Skill else { return }
        
        self.skill = skill
        subSkills.removeAll()
        subSkills = skill.subSkills
    }
}
