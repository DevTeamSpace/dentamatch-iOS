import Foundation
import Swinject
import SwinjectStoryboard

class DMCancelJobInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.trackStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMCancelJobVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMCancelJobVC.self, name: String(describing: DMCancelJobVC.self)) { _, _ in }
    }
}
