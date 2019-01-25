import Foundation
import Swinject
import SwinjectStoryboard

class DMChatInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.messagesStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMChatVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMChatVC.self, name: String(describing: DMChatVC.self)) { _, _ in }
    }
}
