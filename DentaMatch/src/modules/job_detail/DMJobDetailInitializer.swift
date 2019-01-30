import Foundation
import Swinject
import SwinjectStoryboard

class DMJobDetailInitializer {
    
    class func initialize(job: Job?, fromTrack: Bool = false, delegate: JobSavedStatusUpdateDelegate? = nil, moduleOutput: DMJobDetailModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.jobSearchStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMJobDetailVC.self)) as? DMJobDetailVC
        vc?.job = job
        vc?.fromTrack = fromTrack
        vc?.delegate = delegate
        vc?.moduleOutput = moduleOutput
        
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMJobDetailVC.self, name: String(describing: DMJobDetailVC.self)) { _, _ in }
    }
}
