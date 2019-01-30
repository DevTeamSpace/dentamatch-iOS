import Foundation
import Swinject
import SwinjectStoryboard

class DMJobTitleSelectionInitializer {
    
    class func initialize(moduleOutput: DMJobTitleSelectionModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.profileStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMJobTitleSelectionVC.self)) as? DMJobTitleSelectionVC
        vc?.moduleOutput = moduleOutput
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMJobTitleSelectionVC.self, name: String(describing: DMJobTitleSelectionVC.self)) { _, _ in }
    }
}
