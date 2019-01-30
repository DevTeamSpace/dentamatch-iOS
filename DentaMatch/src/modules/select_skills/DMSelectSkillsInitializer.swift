import Foundation
import Swinject
import SwinjectStoryboard

class DMSelectSkillsInitializer {
    
    class func initialize(moduleOutput: DMSelectSkillsModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.profileStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMSelectSkillsVC.self)) as? DMSelectSkillsVC
        vc?.moduleOutput = moduleOutput
        
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMSelectSkillsVC.self, name: String(describing: DMSelectSkillsVC.self)) { _, _ in }
    }
}
