import Foundation
import Swinject
import SwinjectStoryboard

class DMMessagesInitializer {
    
    class func initialize(moduleOutput: DMMessagesModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.messagesStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMMessagesVC.self)) as? DMMessagesVC
        vc?.moduleOutput = moduleOutput
        
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMMessagesVC.self, name: String(describing: DMMessagesVC.self)) { _, _ in }
    }
}
