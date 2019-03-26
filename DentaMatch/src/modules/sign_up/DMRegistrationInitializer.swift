import Foundation
import Swinject
import SwinjectStoryboard

class DMRegistrationInitializer {
    
    class func initialize(moduleOutput: DMRegistrationModuleOutput) -> DMRegistrationModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.registrationStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMRegistrationVC.self)) as? DMRegistrationViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMRegistrationPresenterProtocol.self, arguments: viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMRegistrationPresenterProtocol.self) { r, viewInput, moduleOutput in
            return DMRegistrationPresenter(viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMRegistrationVC.self, name: String(describing: DMRegistrationVC.self)) { _, _ in }
    }
}
