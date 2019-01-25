import Foundation
import Swinject
import SwinjectStoryboard

class SearchStateInitializer {
    
    class func initialize() -> UIViewController {
        return SwinjectStoryboard.create(name: Constants.StoryBoard.states, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: SearchStateViewController.self))
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(SearchStateViewController.self, name: String(describing: SearchStateViewController.self)) { _, _ in }
    }
}
