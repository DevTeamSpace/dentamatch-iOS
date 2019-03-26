import Foundation
import Swinject
import SwinjectStoryboard

class DMNotificationInitializer {
    
    class func initialize(moduleOutput: DMNotificationsModuleOutput) -> DMNotificationsModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.notificationStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMNotificationVC.self)) as? DMNotificationsViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMNotificationsPresenterProtocol.self, arguments: viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMNotificationsPresenterProtocol.self) { r, viewInput, moduleOutput in
            return DMNotificationsPresenter(viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMNotificationVC.self, name: String(describing: DMNotificationVC.self)) { _, _ in }
    }
}
