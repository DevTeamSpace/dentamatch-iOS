import Foundation
import Swinject
import SwinjectStoryboard

class SearchStateInitializer {
    
    class func initialize(preselectedState: String?, delegate: SearchStateViewControllerDelegate?, moduleOutput: SearchStateModuleOutput) -> SearchStateModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.states, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: SearchStateViewController.self)) as? SearchStateViewInput else { return nil }
        
        let presenter = appContainer.resolve(SearchStatePresenterProtocol.self, arguments: preselectedState, delegate, viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(SearchStatePresenterProtocol.self) { r, preselectedState, delegate, viewInput, moduleOutput in
            return SearchStatePresenter(preselectedState: preselectedState, delegate: delegate, viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(SearchStateViewController.self, name: String(describing: SearchStateViewController.self)) { _, _ in }
    }
}
