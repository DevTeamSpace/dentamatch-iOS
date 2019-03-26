import Foundation
import Swinject
import SwinjectStoryboard

class DMSelectSkillsInitializer {
    
    class func initialize(moduleOutput: DMSelectSkillsModuleOutput) -> DMSelectSkillsModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.profileStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMSelectSkillsVC.self)) as? DMSelectSkillsViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMSelectSkillsPresenterProtocol.self, arguments: viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMSelectSkillsPresenterProtocol.self) { r, viewInput, moduleOutput in
            return DMSelectSkillsPresenter(viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMSelectSkillsVC.self, name: String(describing: DMSelectSkillsVC.self)) { _, _ in }
    }
}
