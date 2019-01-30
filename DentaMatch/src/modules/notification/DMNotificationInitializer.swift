import Foundation
import Swinject
import SwinjectStoryboard

class DMNotificationInitializer {
    
    class func initialize(moduleOutput: DMNotificationsModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.notificationStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMNotificationVC.self)) as? DMNotificationVC
        vc?.moduleOutput = moduleOutput
        
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMNotificationVC.self, name: String(describing: DMNotificationVC.self)) { _, _ in }
    }
}
