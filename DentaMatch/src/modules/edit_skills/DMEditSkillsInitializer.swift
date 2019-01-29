import Foundation
import Swinject
import SwinjectStoryboard

class DMEditSkillsInitializer {
    
    class func initialize(skills: [Skill]?, moduleOutput: DMEditSkillsModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.dashboardStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMEditSkillsVC.self)) as? DMEditSkillsVC
        vc?.selectedSkills = skills ?? []
        vc?.moduleOutput = moduleOutput
        
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMEditSkillsVC.self, name: String(describing: DMEditSkillsVC.self)) { _, _ in }
    }
}
