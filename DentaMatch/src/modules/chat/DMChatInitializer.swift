import Foundation
import Swinject
import SwinjectStoryboard

class DMChatInitializer {
    
    class func initialize(chatList: ChatList, delegate: ChatTapNotificationDelegate, fetchFromBegin: Bool, moduleOutput: DMChatModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.messagesStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMChatVC.self)) as? DMChatVC
        vc?.chatList = chatList
        vc?.shouldFetchFromBeginning = fetchFromBegin
        vc?.delegate = delegate
        vc?.moduleOutput = moduleOutput
        
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMChatVC.self, name: String(describing: DMChatVC.self)) { _, _ in }
    }
}
