import Foundation
import Swinject
import SwinjectStoryboard

class DMForgotPasswordInitializer {
    
    class func initialize(moduleOutput: DMForgotPasswordModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.registrationStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMForgotPasswordVC.self)) as? DMForgotPasswordVC
        vc?.moduleOutput = moduleOutput
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMForgotPasswordVC.self, name: String(describing: DMForgotPasswordVC.self)) { _, _ in }
    }
}
