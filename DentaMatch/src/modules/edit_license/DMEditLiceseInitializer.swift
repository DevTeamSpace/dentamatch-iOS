import Foundation
import Swinject
import SwinjectStoryboard

class DMEditLicenseInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.dashboardStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMEditLicenseVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMEditLicenseVC.self, name: String(describing: DMEditLicenseVC.self)) { _, _ in }
    }
}
