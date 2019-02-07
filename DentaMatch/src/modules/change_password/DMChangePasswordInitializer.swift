import Foundation
import Swinject
import SwinjectStoryboard

class DMChangePasswordInitializer {
    
    class func initialize(moduleOutput: DMChangePasswordModuleOutput) -> DMChangePasswordModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.dashboardStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMChangePasswordVC.self)) as? DMChangePasswordViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMChangePasswordPresenterProtocol.self, arguments: viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMChangePasswordPresenterProtocol.self) { r, viewInput, moduleOutput in
            return DMChangePasswordPresenter(viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMChangePasswordVC.self, name: String(describing: DMChangePasswordVC.self)) { _, _ in }
    }
}
