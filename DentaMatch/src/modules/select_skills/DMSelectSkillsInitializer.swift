import Foundation
import Swinject
import SwinjectStoryboard

class DMSelectSkillsInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.profileStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMSelectSkillsVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMSelectSkillsVC.self, name: String(describing: DMSelectSkillsVC.self)) { _, _ in }
    }
}
