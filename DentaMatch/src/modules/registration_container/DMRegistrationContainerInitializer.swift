import Foundation
import Swinject
import SwinjectStoryboard

class DMRegistrationContainerInitializer {
    
    class func initialize(moduleOutput: DMRegistrationContainerModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.registrationStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMRegistrationContainer.self)) as? DMRegistrationContainer
        vc?.moduleOutput = moduleOutput
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMRegistrationContainer.self, name: String(describing: DMRegistrationContainer.self)) { _, _ in }
    }
}
