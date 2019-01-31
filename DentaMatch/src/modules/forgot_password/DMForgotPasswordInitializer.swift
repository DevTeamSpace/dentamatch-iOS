import Foundation
import Swinject
import SwinjectStoryboard

class DMForgotPasswordInitializer {
    
    class func initialize(moduleOutput: DMForgotPasswordModuleOutput) -> DMForgotPasswordModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.registrationStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMForgotPasswordVC.self)) as? DMForgotPasswordViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMForgotPasswordPresenterProtocol.self, arguments: viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMForgotPasswordPresenterProtocol.self) { r, viewInput, moduleOutput in
            return DMForgotPasswordPresenter(viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMForgotPasswordVC.self, name: String(describing: DMForgotPasswordVC.self)) { _, _ in }
    }
}
