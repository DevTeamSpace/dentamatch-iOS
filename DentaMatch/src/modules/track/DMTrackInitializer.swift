import Foundation
import Swinject
import SwinjectStoryboard

class DMTrackInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.trackStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMTrackVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMTrackVC.self, name: String(describing: DMTrackVC.self)) { _, _ in }
    }
}
