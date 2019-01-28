import Foundation
import Swinject
import SwinjectStoryboard

class TabBarInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.dashboardStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: TabBarVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(TabBarVC.self, name: String(describing: TabBarVC.self)) { _, _ in }
    }
}
