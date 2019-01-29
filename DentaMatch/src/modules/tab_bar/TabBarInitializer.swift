import Foundation
import Swinject
import SwinjectStoryboard

class TabBarInitializer {
    
    class func initialize(moduleOutput: TabBarModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.dashboardStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: TabBarVC.self)) as? TabBarVC
        vc?.moduleOutput = moduleOutput
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(TabBarVC.self, name: String(describing: TabBarVC.self)) { _, _ in }
    }
}
