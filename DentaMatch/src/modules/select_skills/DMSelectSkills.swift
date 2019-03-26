import Foundation

protocol DMSelectSkillsModuleInput: BaseModuleInput {
    
}

protocol DMSelectSkillsModuleOutput: BaseModuleOutput {
    
}

protocol DMSelectSkillsViewInput: BaseViewInput {
    var viewOutput: DMSelectSkillsViewOutput? { get set }
    
    func reloadData()
}

protocol DMSelectSkillsViewOutput: BaseViewOutput {
    var skill: Skill? { get set }
    var subSkills: [SubSkill] { get set }
    var subSkillWithoutOther: [SubSkill] { get set }
    var otherSkill: SubSkill? { get set }
    var otherText: String { get set }
    
    func didLoad()
    func willAppear()
}

protocol DMSelectSkillsPresenterProtocol: DMSelectSkillsModuleInput, DMSelectSkillsViewOutput {
    
}
