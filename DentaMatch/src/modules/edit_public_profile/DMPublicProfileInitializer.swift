import Foundation
import Swinject
import SwinjectStoryboard

class DMPublicProfileInitializer {
    
    class func initialize(jobTitles: [JobTitle]?, selectedJob: JobTitle?, moduleOutput: DMPublicProfileModuleOutput) -> DMPublicProfileModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.dashboardStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMPublicProfileVC.self)) as? DMPublicProfileViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMPublicProfilePresenterProtocol.self, arguments: jobTitles, selectedJob, viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMPublicProfilePresenterProtocol.self) { r, jobTitles, selectedJob, viewInput, moduleOutput in
            return DMPublicProfilePresenter(jobTitles: jobTitles, selectedJob: selectedJob, viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMPublicProfileVC.self, name: String(describing: DMPublicProfileVC.self)) { _, _ in }
    }
}
