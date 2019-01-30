import Foundation
import Swinject
import SwinjectStoryboard

class DMEditProfileInitializer {
    
    class func initialize(moduleOutput: DMEditProfileModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.dashboardStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMEditProfileVC.self)) as? DMEditProfileVC
        vc?.moduleOutput = moduleOutput
        
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMEditProfileVC.self, name: String(describing: DMEditProfileVC.self)) { _, _ in }
    }
}
