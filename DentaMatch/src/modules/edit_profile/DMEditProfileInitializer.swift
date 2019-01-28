import Foundation
import Swinject
import SwinjectStoryboard

class DMEditProfileInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.dashboardStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMEditProfileVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMEditProfileVC.self, name: String(describing: DMEditProfileVC.self)) { _, _ in }
    }
}
