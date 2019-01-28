import Foundation
import Swinject
import SwinjectStoryboard

class DMCalendarInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.calenderStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMCalenderVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMCalenderVC.self, name: String(describing: DMCalenderVC.self)) { _, _ in }
    }
}
