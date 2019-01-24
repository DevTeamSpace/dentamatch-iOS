import Foundation
import Swinject
import SwinjectStoryboard

class DMJobSearchResultInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.jobSearchStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMJobSearchResultVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMJobSearchResultVC.self, name: String(describing: DMJobSearchResultVC.self)) { _, _ in }
    }
}
