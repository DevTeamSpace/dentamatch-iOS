import Foundation
import Swinject
import SwinjectStoryboard

class DMNotificationInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.notificationStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMNotificationVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMNotificationVC.self, name: String(describing: DMNotificationVC.self)) { _, _ in }
    }
}
