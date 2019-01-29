import Foundation
import Swinject
import SwinjectStoryboard

class DMCalendarSetAvailabilityInitializer {
    
    class func initialize(fromJobSelection: Bool = false, moduleOutput: DMCalendarSetAvailabilityModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.calenderStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMCalendarSetAvailabillityVC.self)) as? DMCalendarSetAvailabillityVC
        vc?.fromJobSelection = fromJobSelection
        vc?.moduleOutput = moduleOutput
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMCalendarSetAvailabillityVC.self, name: String(describing: DMCalendarSetAvailabillityVC.self)) { _, _ in }
    }
}
