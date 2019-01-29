import Foundation
import Swinject
import SwinjectStoryboard

class DMCalendarInitializer {
    
    class func initialize(moduleOutput: DMCalendarModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.calenderStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMCalenderVC.self)) as? DMCalenderVC
        vc?.moduleOutput = moduleOutput
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMCalenderVC.self, name: String(describing: DMCalenderVC.self)) { _, _ in }
    }
}
