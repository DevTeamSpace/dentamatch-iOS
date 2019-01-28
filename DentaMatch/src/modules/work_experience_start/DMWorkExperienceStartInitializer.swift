import Foundation
import Swinject
import SwinjectStoryboard

class DMWorkExperienceStartInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.profileStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMWorkExperienceStart.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMWorkExperienceStart.self, name: String(describing: DMWorkExperienceStart.self)) { _, _ in }
    }
}
