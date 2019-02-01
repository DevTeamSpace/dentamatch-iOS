import Foundation
import Swinject
import SwinjectStoryboard

class DMProfileSuccessPendingInitializer {
    
    class func initialize(isEmailVerified: Bool = false, isLicenseRequired: Bool = false, fromRoot: Bool = false, moduleOutput: DMProfileSuccessPendingModuleOutput) -> DMProfileSuccessPendingModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.profileStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMProfileSuccessPending.self)) as? DMProfileSuccessPendingViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMProfileSuccessPendingPresenterProtocol.self, arguments: isEmailVerified, isLicenseRequired, fromRoot, viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMProfileSuccessPendingPresenterProtocol.self) { r, isEmailVerified, isLicenseRequired, fromRoot, viewInput, moduleOutput in
            return DMProfileSuccessPendingPresenter(isEmailVerified: isEmailVerified, isLicenseRequired: isLicenseRequired, fromRoot: fromRoot, viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMProfileSuccessPending.self, name: String(describing: DMProfileSuccessPending.self)) { _, _ in }
    }
}
