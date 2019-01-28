import Foundation
import Swinject
import SwinjectStoryboard

class DMCommonSuccessFailureInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.profileStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMCommonSuccessFailureVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMCommonSuccessFailureVC.self, name: String(describing: DMCommonSuccessFailureVC.self)) { _, _ in }
    }
}
