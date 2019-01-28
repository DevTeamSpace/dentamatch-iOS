import Foundation
import Swinject
import SwinjectStoryboard

class DMCertificationsInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.profileStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMCertificationsVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMCertificationsVC.self, name: String(describing: DMCertificationsVC.self)) { _, _ in }
    }
}
