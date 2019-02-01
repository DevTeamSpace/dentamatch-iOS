import Foundation
import Swinject
import SwinjectStoryboard

class DMJobTitleSelectionInitializer {
    
    class func initialize(moduleOutput: DMJobTitleSelectionModuleOutput) -> DMJobTitleSelectionModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.profileStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMJobTitleSelectionVC.self)) as? DMJobTitleSelectionViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMJobTitleSelectionPresenterProtocol.self, arguments: viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMJobTitleSelectionPresenterProtocol.self) { r, viewInput, moduleOutput in
            return DMJobTitleSelectionPresenter(viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMJobTitleSelectionVC.self, name: String(describing: DMJobTitleSelectionVC.self)) { _, _ in }
    }
}
