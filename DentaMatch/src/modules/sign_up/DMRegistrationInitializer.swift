import Foundation
import Swinject
import SwinjectStoryboard

class DMRegistrationInitializer {
    
    class func initialize(moduleOutput: DMRegistrationModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.registrationStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMRegistrationVC.self)) as? DMRegistrationVC
        vc?.moduleOutput = moduleOutput
        
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMRegistrationVC.self, name: String(describing: DMRegistrationVC.self)) { _, _ in }
    }
}
