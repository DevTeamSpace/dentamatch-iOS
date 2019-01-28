import Foundation
import Swinject
import SwinjectStoryboard

class DMCalendarSetAvailabilityInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.calenderStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMCalendarSetAvailabillityVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMCalendarSetAvailabillityVC.self, name: String(describing: DMCalendarSetAvailabillityVC.self)) { _, _ in }
    }
}
