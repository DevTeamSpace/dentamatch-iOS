import Foundation
import Swinject
import SwinjectStoryboard

class DMWorkExperienceInitializer {
    
    class func initialize(jobTitles: [JobTitle]?, isEditMode: Bool, moduleOutput: DMWorkExperienceModuleOutput) -> DMWorkExperienceModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.profileStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMWorkExperienceVC.self)) as? DMWorkExperienceViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMWorkExperiencePresenterProtocol.self, arguments: jobTitles, isEditMode, viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMWorkExperiencePresenterProtocol.self) { r, jobTitles, isEditMode, viewInput, moudleOutput in
            return DMWorkExperiencePresenter(jobTitles: jobTitles, isEditing: isEditMode, viewInput: viewInput, moduleOutput: moudleOutput)
        }
        
        container.storyboardInitCompleted(DMWorkExperienceVC.self, name: String(describing: DMWorkExperienceVC.self)) { _, _ in }
    }
}
