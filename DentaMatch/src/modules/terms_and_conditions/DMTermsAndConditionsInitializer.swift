import Foundation
import Swinject
import SwinjectStoryboard

class DMTermsAndConditionsInitializer {
    
    class func initialize(isPrivacyPolicy: Bool, moduleOutput: DMTermsAndConditionsModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.registrationStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMTermsAndConditionsVC.self)) as? DMTermsAndConditionsVC
        vc?.isPrivacyPolicy = isPrivacyPolicy
        vc?.moduleOutput = moduleOutput
        
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMTermsAndConditionsVC.self, name: String(describing: DMTermsAndConditionsVC.self)) { _, _ in }
    }
}
