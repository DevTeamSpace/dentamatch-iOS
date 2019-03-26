import Foundation
import Swinject
import SwinjectStoryboard

class DMEditCertificateInitializer {
    
    class func initialize(certificate: Certification?, isEditMode: Bool, moduleOutput: DMEditCertificateModuleOutput) -> DMEditCertificateModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.dashboardStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMEditCertificateVC.self)) as? DMEditCertificateViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMEditCertificatePresenterProtocol.self, arguments: certificate, isEditMode, viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMEditCertificatePresenterProtocol.self) { r, certificate, isEditMode, viewInput, moduleOutput in
            return DMEditCertificatePresenter(certificate: certificate, isEditing: isEditMode, viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMEditCertificateVC.self, name: String(describing: DMEditCertificateVC.self)) { _, _ in }
    }
}
