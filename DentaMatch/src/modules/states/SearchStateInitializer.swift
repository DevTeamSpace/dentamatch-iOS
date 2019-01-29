import Foundation
import Swinject
import SwinjectStoryboard

class SearchStateInitializer {
    
    class func initialize(preselectedState: String?, delegate: SearchStateViewControllerDelegate?, moduleOutput: SearchStateModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.states, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: SearchStateViewController.self)) as? SearchStateViewController
        vc?.preSelectedState = preselectedState
        vc?.delegate = delegate
        vc?.moduleOutput = moduleOutput
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(SearchStateViewController.self, name: String(describing: SearchStateViewController.self)) { _, _ in }
    }
}
