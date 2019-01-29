import Foundation
import Swinject
import SwinjectStoryboard

class DMPublicProfileInitializer {
    
    class func initialize(jobTitles: [JobTitle]?, selectedJob: JobTitle?, moduleOutput: DMPublicProfileModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.dashboardStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMPublicProfileVC.self)) as? DMPublicProfileVC
        vc?.jobTitles = jobTitles ?? []
        vc?.selectedJob = selectedJob ?? JobTitle()
        vc?.moduleOutput = moduleOutput
        
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMPublicProfileVC.self, name: String(describing: DMPublicProfileVC.self)) { _, _ in }
    }
}
