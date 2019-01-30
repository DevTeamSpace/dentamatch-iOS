import Foundation
import Swinject
import SwinjectStoryboard

class DMProfileSuccessPendingInitializer {
    
    class func initialize(isEmailVerified: Bool = false, isLicenseRequired: Bool = false, fromRoot: Bool = false, moduleOutput: DMProfileSuccessPendingModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.profileStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMProfileSuccessPending.self)) as? DMProfileSuccessPending
        vc?.isEmailVerified = isEmailVerified
        vc?.isLicenseRequired = isLicenseRequired
        vc?.fromRoot = fromRoot
        vc?.moduleOutput = moduleOutput
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMProfileSuccessPending.self, name: String(describing: DMProfileSuccessPending.self)) { _, _ in }
    }
}
