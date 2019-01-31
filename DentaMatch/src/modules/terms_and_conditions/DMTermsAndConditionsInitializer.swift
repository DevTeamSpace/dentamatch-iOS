import Foundation
import Swinject
import SwinjectStoryboard

class DMTermsAndConditionsInitializer {
    
    class func initialize(isPrivacyPolicy: Bool, moduleOutput: DMTermsAndConditionsModuleOutput) -> DMTermsAndConditionsModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.registrationStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMTermsAndConditionsVC.self)) as? DMTermsAndConditionsViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMTermsAndConditionsPresenterProtocol.self, arguments: isPrivacyPolicy, viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMTermsAndConditionsPresenterProtocol.self) { r, isPrivacyPolicy, viewInput, moduleOutput in
            return DMTermsAndConditionsPresenter(isPrivacyPolicy: isPrivacyPolicy, viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMTermsAndConditionsVC.self, name: String(describing: DMTermsAndConditionsVC.self)) { _, _ in }
    }
}
