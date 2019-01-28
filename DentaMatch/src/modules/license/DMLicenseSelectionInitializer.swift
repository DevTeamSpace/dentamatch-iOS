import Foundation
import Swinject
import SwinjectStoryboard

class DMLicenseSelectionInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.profileStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMLicenseSelectionVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMLicenseSelectionVC.self, name: String(describing: DMLicenseSelectionVC.self)) { _, _ in }
    }
}
