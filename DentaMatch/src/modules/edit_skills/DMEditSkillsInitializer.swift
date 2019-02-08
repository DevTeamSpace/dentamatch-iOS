import Foundation
import Swinject
import SwinjectStoryboard

class DMEditSkillsInitializer {
    
    class func initialize(skills: [Skill]?, moduleOutput: DMEditSkillsModuleOutput) -> DMEditSkillsModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.dashboardStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMEditSkillsVC.self)) as? DMEditSkillsViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMEditSkillsPresenterProtocol.self, arguments: skills, viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMEditSkillsPresenterProtocol.self) { r, skills, viewInput, moduleOutput in
            return DMEditSkillsPresenter(skills: skills, viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMEditSkillsVC.self, name: String(describing: DMEditSkillsVC.self)) { _, _ in }
    }
}
