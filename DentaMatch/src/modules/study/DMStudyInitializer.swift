import Foundation
import Swinject
import SwinjectStoryboard

class DMStudyInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.profileStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMStudyVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMStudyVC.self, name: String(describing: DMStudyVC.self)) { _, _ in }
    }
}
