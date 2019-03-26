import Foundation
import Swinject
import SwinjectStoryboard

class DMOnboardingInitializer {
    
    class func initialize(moduleOutput: DMOnboardingModuleOutput) -> DMOnboardingModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.onBoardingStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMOnboardingVC.self)) as? DMOnboardingViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMOnboardingPresenterProtocol.self, arguments: viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMOnboardingPresenterProtocol.self) { r, viewInput, moduleOutput in
            return DMOnboardingPresenter(viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMOnboardingVC.self, name: String(describing: DMOnboardingVC.self)) { _, _ in }
    }
}
