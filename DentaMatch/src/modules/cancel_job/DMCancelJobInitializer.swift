import Foundation
import Swinject
import SwinjectStoryboard

class DMCancelJobInitializer {
    
    class func initialize(job: Job?, fromApplied: Bool, delegate: CancelledJobDelegate, moduleOutput: DMCancelJobModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.trackStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMCancelJobVC.self)) as? DMCancelJobVC
        vc?.job = job
        vc?.fromApplied = fromApplied
        vc?.delegate = delegate
        vc?.moduleOutput = moduleOutput
        
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMCancelJobVC.self, name: String(describing: DMCancelJobVC.self)) { _, _ in }
    }
}
