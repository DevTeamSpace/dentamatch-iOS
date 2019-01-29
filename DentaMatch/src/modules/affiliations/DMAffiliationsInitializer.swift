import Foundation
import Swinject
import SwinjectStoryboard

class DMAffiliationsInitializer {
    
    class func initialize(selectedAffiliations: [Affiliation]?, isEditMode: Bool, moduleOutput: DMAffiliationsModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.profileStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMAffiliationsVC.self)) as? DMAffiliationsVC
        vc?.selectedAffiliationsFromProfile = selectedAffiliations ?? []
        vc?.isEditMode = isEditMode
        vc?.moduleOutput = moduleOutput
        
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMAffiliationsVC.self, name: String(describing: DMAffiliationsVC.self)) { _, _ in }
    }
}
