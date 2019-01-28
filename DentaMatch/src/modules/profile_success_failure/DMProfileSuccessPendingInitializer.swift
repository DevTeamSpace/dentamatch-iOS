import Foundation
import Swinject
import SwinjectStoryboard

class DMProfileSuccessPendingInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.profileStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMProfileSuccessPending.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMProfileSuccessPending.self, name: String(describing: DMProfileSuccessPending.self)) { _, _ in }
    }
}
