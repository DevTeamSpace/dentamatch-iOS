import Foundation
import Swinject
import SwinjectStoryboard

class DMEditSkillsInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.dashboardStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMEditSkillsVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMEditSkillsVC.self, name: String(describing: DMEditSkillsVC.self)) { _, _ in }
    }
}
