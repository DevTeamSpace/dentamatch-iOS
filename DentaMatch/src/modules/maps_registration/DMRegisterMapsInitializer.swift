import Foundation
import Swinject
import SwinjectStoryboard

class DMRegisterMapsInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.registrationStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMRegisterMapsVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMRegisterMapsVC.self, name: String(describing: DMRegisterMapsVC.self)) { _, _ in }
    }
}
