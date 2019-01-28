import Foundation
import Swinject
import SwinjectStoryboard

class DMEditCertificateInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.dashboardStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMEditCertificateVC.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMEditCertificateVC.self, name: String(describing: DMEditCertificateVC.self)) { _, _ in }
    }
}
