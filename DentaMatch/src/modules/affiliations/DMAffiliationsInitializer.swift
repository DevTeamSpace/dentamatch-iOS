import Foundation
import Swinject
import SwinjectStoryboard

class DMAffiliationsInitializer {
    
    class func initialize(selectedAffiliations: [Affiliation]?, isEditMode: Bool, moduleOutput: DMAffiliationsModuleOutput) -> DMAffiliationsModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.profileStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMAffiliationsVC.self)) as? DMAffiliationsViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMAffiliationsPresenterProtocol.self, arguments: selectedAffiliations, isEditMode, viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMAffiliationsPresenterProtocol.self) { r, affiliations, isEditing, viewInput, moduleOutput in
            return DMAffiliationsPresenter(affiliations: affiliations, isEditing: isEditing, viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMAffiliationsVC.self, name: String(describing: DMAffiliationsVC.self)) { _, _ in }
    }
}
