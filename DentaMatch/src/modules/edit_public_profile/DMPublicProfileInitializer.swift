import Foundation
import Swinject
import SwinjectStoryboard

class DMPublicProfileInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.dashboardStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMPublicProfileVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMPublicProfileVC.self, name: String(describing: DMPublicProfileVC.self)) { _, _ in }
    }
}
