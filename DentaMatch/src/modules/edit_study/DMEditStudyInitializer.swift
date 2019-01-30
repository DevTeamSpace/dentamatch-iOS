import Foundation
import Swinject
import SwinjectStoryboard

class DMEditStudyInitializer {
    
    class func initialize(selectedSchoolCategories: [SelectedSchool]?, moduleOutput: DMEditStudyModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.dashboardStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMEditStudyVC.self)) as? DMEditStudyVC
        vc?.selectedSchoolCategories = selectedSchoolCategories ?? []
        vc?.moduleOutput = moduleOutput
        
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMEditStudyVC.self, name: String(describing: DMEditStudyVC.self)) { _, _ in }
    }
}
