import Foundation
import Swinject
import SwinjectStoryboard

class DMSchoolListPopOverInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.profileStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMSchoolListPopOverVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMSchoolListPopOverVC.self, name: String(describing: DMSchoolListPopOverVC.self)) { _, _ in }
    }
}
