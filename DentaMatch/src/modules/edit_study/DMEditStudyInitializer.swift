import Foundation
import Swinject
import SwinjectStoryboard

class DMEditStudyInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.dashboardStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMEditStudyVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMEditStudyVC.self, name: String(describing: DMEditStudyVC.self)) { _, _ in }
    }
}
