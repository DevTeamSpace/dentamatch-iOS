import Foundation
import Swinject
import SwinjectStoryboard

class DMEditProfileInitializer {
    
    class func initialize(moduleOutput: DMEditProfileModuleOutput) -> DMEditProfileModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.dashboardStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMEditProfileVC.self)) as? DMEditProfileViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMEditProfilePresenterProtocol.self, arguments: viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMEditProfilePresenterProtocol.self) { r, viewInput, moduleOutput in
            return DMEditProfilePresenter(viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMEditProfileVC.self, name: String(describing: DMEditProfileVC.self)) { _, _ in }
    }
}
