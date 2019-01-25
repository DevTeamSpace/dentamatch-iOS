import Foundation
import Swinject
import SwinjectStoryboard

class DMAffiliationsInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.profileStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMAffiliationsVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMAffiliationsVC.self, name: String(describing: DMAffiliationsVC.self)) { _, _ in }
    }
}
