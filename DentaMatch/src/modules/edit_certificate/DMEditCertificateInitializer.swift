import Foundation
import Swinject
import SwinjectStoryboard

class DMEditCertificateInitializer {
    
    class func initialize(certificate: Certification?, isEditMode: Bool, moduleOutput: DMEditCertificateModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.dashboardStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMEditCertificateVC.self)) as? DMEditCertificateVC
        vc?.certificate = certificate
        vc?.isEditMode = isEditMode
        vc?.moduleOutput = moduleOutput
        
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMEditCertificateVC.self, name: String(describing: DMEditCertificateVC.self)) { _, _ in }
    }
}
