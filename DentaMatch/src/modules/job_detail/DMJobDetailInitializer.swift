import Foundation
import Swinject
import SwinjectStoryboard

class DMJobDetailInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.jobSearchStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMJobDetailVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMJobDetailVC.self, name: String(describing: DMJobDetailVC.self)) { _, _ in }
    }
}
