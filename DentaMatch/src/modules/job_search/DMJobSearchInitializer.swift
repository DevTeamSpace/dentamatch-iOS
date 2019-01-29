import Foundation
import Swinject
import SwinjectStoryboard

class DMJobSearchInitializer {
    
    class func initialize(fromJobResult: Bool, delegate: SearchJobDelegate, moduleOutput: DMJobSearchModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.jobSearchStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMJobSearchVC.self)) as? DMJobSearchVC
        vc?.fromJobSearchResults = fromJobResult
        vc?.delegate = delegate
        vc?.moduleOutput = moduleOutput
        
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMJobSearchVC.self, name: String(describing: DMJobSearchVC.self)) { _, _ in }
    }
}
