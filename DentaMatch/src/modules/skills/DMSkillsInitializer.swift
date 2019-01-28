import Foundation
import Swinject
import SwinjectStoryboard

class DMSkillsInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.profileStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMSkillsVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMSkillsVC.self, name: String(describing: DMSkillsVC.self)) { _, _ in }
    }
}
