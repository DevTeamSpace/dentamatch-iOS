import Foundation
import Swinject
import SwinjectStoryboard

class DMChatInitializer {
    
    class func initialize(chatObject: ChatObject, moduleOutput: DMChatModuleOutput) -> DMChatModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.messagesStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMChatVC.self)) as? DMChatViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMChatPresenterProtocol.self, arguments: chatObject, viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMChatPresenterProtocol.self) { r, chatObject, viewInput, moduleOutput in
            return DMChatPresenter(chatObject: chatObject, viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMChatVC.self, name: String(describing: DMChatVC.self)) { _, _ in }
    }
}
