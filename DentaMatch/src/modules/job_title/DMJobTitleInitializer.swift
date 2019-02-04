import Foundation
import Swinject
import SwinjectStoryboard

class DMJobTitleInitializer {
    
    class func initialize(selectedTitles: [JobTitle]?, forLocation: Bool, locations: [PreferredLocation]?, delegate: DMJobTitleVCDelegate, moduleOutput: DMJobTitleModuleOutput) -> DMJobTitleModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.jobSearchStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMJobTitleVC.self)) as? DMJobTitleViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMJobTitlePresenterProtocol.self, arguments: selectedTitles, forLocation, locations, delegate, viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMJobTitlePresenterProtocol.self) { r, selectedTitles, forLocation, locations, delegate, viewInput, moduleOutput in
            return DMJobTitlePresenter(selectedTitles: selectedTitles, forLocation: forLocation, locations: locations, delegate: delegate, viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMJobTitleVC.self, name: String(describing: DMJobTitleVC.self)) { _, _ in }
    }
}
