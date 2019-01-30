import Foundation
import Swinject
import SwinjectStoryboard

class DMJobTitleInitializer {
    
    class func initialize(selectedTitles: [JobTitle]?, forLocation: Bool, locations: [PreferredLocation]?, delegate: DMJobTitleVCDelegate, moduleOutput: DMJobTitleModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.jobSearchStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMJobTitleVC.self)) as? DMJobTitleVC
        vc?.selectedJobs = selectedTitles ?? []
        vc?.forPreferredLocations = forLocation
        vc?.preferredLocations = locations ?? []
        vc?.delegate = delegate
        
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMJobTitleVC.self, name: String(describing: DMJobTitleVC.self)) { _, _ in }
    }
}
