import Foundation
import Swinject
import SwinjectStoryboard

class DMExecutiveSummaryInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.profileStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMExecutiveSummaryVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMExecutiveSummaryVC.self, name: String(describing: DMExecutiveSummaryVC.self)) { _, _ in }
    }
}
