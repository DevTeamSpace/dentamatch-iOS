import Foundation
import Swinject
import SwinjectStoryboard

class DMLoginInitializer {
    
    class func initialize(moduleOutput: DMLoginModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.registrationStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMLoginVC.self)) as? DMLoginVC
        vc?.moduleOutput = moduleOutput
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMLoginVC.self, name: String(describing: DMLoginVC.self)) { _, _ in }
    }
}
