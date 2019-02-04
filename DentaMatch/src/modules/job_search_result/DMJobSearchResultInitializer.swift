import Foundation
import Swinject
import SwinjectStoryboard

class DMJobSearchResultInitializer {
    
    class func initialize(moduleOutput: DMJobSearchResultModuleOutput) -> DMJobSearchResultModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.jobSearchStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMJobSearchResultVC.self)) as? DMJobSearchResultViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMJobSearchResultPresenterProtocol.self, arguments: viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMJobSearchResultPresenterProtocol.self) { r, viewInput, moduleOutput in
            return DMJobSearchResultPresenter(viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMJobSearchResultVC.self, name: String(describing: DMJobSearchResultVC.self)) { _, _ in }
    }
}
