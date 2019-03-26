import Foundation
import Swinject
import SwinjectStoryboard

class DMMessagesInitializer {
    
    class func initialize(moduleOutput: DMMessagesModuleOutput) -> DMMessagesModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.messagesStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMMessagesVC.self)) as? DMMessagesViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMMessagesPresenterProtocol.self, arguments: viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMMessagesPresenterProtocol.self) { r, viewInput, moduleOutput in
            return DMMessagesPresenter(viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMMessagesVC.self, name: String(describing: DMMessagesVC.self)) { _, _ in }
    }
}
