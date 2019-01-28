import Foundation
import Swinject
import SwinjectStoryboard

class DMJobSearchInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.jobSearchStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMJobSearchVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMJobSearchVC.self, name: String(describing: DMJobSearchVC.self)) { _, _ in }
    }
}
