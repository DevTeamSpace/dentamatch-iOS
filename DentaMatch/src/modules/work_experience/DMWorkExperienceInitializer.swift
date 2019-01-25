import Foundation
import Swinject
import SwinjectStoryboard

class DMWorkExperienceInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.profileStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMWorkExperienceVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMWorkExperienceVC.self, name: String(describing: DMWorkExperienceVC.self)) { _, _ in }
    }
}
