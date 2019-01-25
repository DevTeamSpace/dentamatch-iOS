import Foundation
import Swinject
import SwinjectStoryboard

class DMEditDentalStateInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.dashboardStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMEditDentalStateBoardVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMEditDentalStateBoardVC.self, name: String(describing: DMEditDentalStateBoardVC.self)) { _, _ in }
    }
}
