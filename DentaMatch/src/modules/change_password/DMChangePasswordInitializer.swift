import Foundation
import Swinject
import SwinjectStoryboard

class DMChangePasswordInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.dashboardStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMChangePasswordVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMChangePasswordVC.self, name: String(describing: DMChangePasswordVC.self)) { _, _ in }
    }
}
