import Foundation
import Swinject
import SwinjectStoryboard

class DMTrackInitializer {
    
    class func initialize(moduleOutput: DMTrackModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.trackStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMTrackVC.self)) as? DMTrackVC
        vc?.moduleOutput = moduleOutput
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMTrackVC.self, name: String(describing: DMTrackVC.self)) { _, _ in }
    }
}
