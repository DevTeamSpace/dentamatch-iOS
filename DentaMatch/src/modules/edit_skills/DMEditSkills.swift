import Foundation

protocol DMEditSkillsModuleInput: BaseModuleInput {
    
}

protocol DMEditSkillsModuleOutput: BaseModuleOutput {
    
}

protocol DMEditSkillsViewInput: BaseViewInput {
    var viewOutput: DMEditSkillsViewOutput? { get set }
    
    func reloadData()
}

protocol DMEditSkillsViewOutput: BaseViewOutput {
    var skills: [Skill] { get set }
    var otherSkill: Skill? { get set }
    var selectedSkills: [Skill] { get set }
    
    func getSkillList()
    func onSaveButtonTap()
}

protocol DMEditSkillsPresenterProtocol: DMEditSkillsModuleInput, DMEditSkillsViewOutput {
    
}
