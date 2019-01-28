import Foundation
import Swinject
import SwinjectStoryboard

class DMTermsAndConditionsInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.registrationStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMTermsAndConditionsVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMTermsAndConditionsVC.self, name: String(describing: DMTermsAndConditionsVC.self)) { _, _ in }
    }
}
