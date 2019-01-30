import Foundation
import Swinject
import SwinjectStoryboard

class DMJobSearchResultInitializer {
    
    class func initialize(moduleOutput: DMJobSearchResultModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.jobSearchStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMJobSearchResultVC.self)) as? DMJobSearchResultVC
        vc?.moduleOutput = moduleOutput
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMJobSearchResultVC.self, name: String(describing: DMJobSearchResultVC.self)) { _, _ in }
    }
}
