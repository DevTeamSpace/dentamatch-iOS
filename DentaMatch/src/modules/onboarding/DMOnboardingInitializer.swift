import Foundation
import Swinject
import SwinjectStoryboard

class DMOnboardingInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.onBoardingStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMOnboardingVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMOnboardingVC.self, name: String(describing: DMOnboardingVC.self)) { _, _ in }
    }
}
