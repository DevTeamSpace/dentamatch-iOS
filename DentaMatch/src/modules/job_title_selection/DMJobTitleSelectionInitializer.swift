import Foundation
import Swinject
import SwinjectStoryboard

class DMJobTitleSelectionInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.profileStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMJobTitleSelectionVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMJobTitleSelectionVC.self, name: String(describing: DMJobTitleSelectionVC.self)) { _, _ in }
    }
}
