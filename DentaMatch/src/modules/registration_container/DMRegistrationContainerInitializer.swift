import Foundation
import Swinject
import SwinjectStoryboard

class DMRegistrationContainerInitializer {
    
    class func initialize(moduleOutput: DMRegistrationContainerModuleOutput) -> DMRegistrationContainerModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.registrationStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMRegistrationContainer.self)) as? DMRegistrationContainerViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMRegistrationContainerPresenterProtocol.self, arguments: viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMRegistrationContainerPresenterProtocol.self) { r, viewInput, moduleOutput in
            return DMRegistrationContainerPresenter(viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMRegistrationContainer.self, name: String(describing: DMRegistrationContainer.self)) { _, _ in }
    }
}
