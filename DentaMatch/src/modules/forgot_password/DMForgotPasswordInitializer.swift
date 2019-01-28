import Foundation
import Swinject
import SwinjectStoryboard

class DMForgotPasswordInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.registrationStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMForgotPasswordVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMForgotPasswordVC.self, name: String(describing: DMForgotPasswordVC.self)) { _, _ in }
    }
}
