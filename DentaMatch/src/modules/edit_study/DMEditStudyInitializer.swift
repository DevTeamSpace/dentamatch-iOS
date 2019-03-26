import Foundation
import Swinject
import SwinjectStoryboard

class DMEditStudyInitializer {
    
    class func initialize(selectedSchoolCategories: [SelectedSchool]?, moduleOutput: DMEditStudyModuleOutput) -> DMEditStudyModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.dashboardStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMEditStudyVC.self)) as? DMEditStudyViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMEditStudyPresenterProtocol.self, arguments: selectedSchoolCategories, viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMEditStudyPresenterProtocol.self) { r, selectedSchoolCategories, viewInput, moduleOutput in
            return DMEditStudyPresenter(selectedCategories: selectedSchoolCategories, viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMEditStudyVC.self, name: String(describing: DMEditStudyVC.self)) { _, _ in }
    }
}
