import Foundation
import Swinject
import SwinjectStoryboard

class DMOnboardingInitializer {
    
    class func initialize(moduleOutput: DMOnboardingModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.onBoardingStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMOnboardingVC.self)) as? DMOnboardingVC
        vc?.moduleOutput = moduleOutput
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMOnboardingVC.self, name: String(describing: DMOnboardingVC.self)) { _, _ in }
    }
}
