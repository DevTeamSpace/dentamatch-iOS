import Foundation
import Swinject
import SwinjectStoryboard

class DMChangePasswordInitializer {
    
    class func initialize(moduleOutput: DMChangePasswordModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.dashboardStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMChangePasswordVC.self)) as? DMChangePasswordVC
        vc?.moduleOutput = moduleOutput
        
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMChangePasswordVC.self, name: String(describing: DMChangePasswordVC.self)) { _, _ in }
    }
}
