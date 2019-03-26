import Foundation
import Swinject
import SwinjectStoryboard

class DMLoginInitializer {
    
    class func initialize(moduleOutput: DMLoginModuleOutput) -> DMLoginModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.registrationStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMLoginVC.self)) as? DMLoginViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMLoginPresenterProtocol.self, arguments: viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMLoginPresenterProtocol.self) { r, viewInput, moduleOutput in
            return DMLoginPresenter(viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMLoginVC.self, name: String(describing: DMLoginVC.self)) { _, _ in }
    }
}
