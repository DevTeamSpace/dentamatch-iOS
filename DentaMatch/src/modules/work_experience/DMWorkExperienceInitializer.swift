import Foundation
import Swinject
import SwinjectStoryboard

class DMWorkExperienceInitializer {
    
    class func initialize(jobTitles: [JobTitle]?, isEditMode: Bool, moduleOutput: DMWorkExperienceModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.profileStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMWorkExperienceVC.self)) as? DMWorkExperienceVC
        vc?.jobTitles = jobTitles ?? []
        vc?.isEditMode = isEditMode
        vc?.moduleOutput = moduleOutput
        
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMWorkExperienceVC.self, name: String(describing: DMWorkExperienceVC.self)) { _, _ in }
    }
}
