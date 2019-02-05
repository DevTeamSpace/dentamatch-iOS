import Foundation
import Swinject
import SwinjectStoryboard

class DMTrackInitializer {
    
    class func initialize(moduleOutput: DMTrackModuleOutput) -> DMTrackModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.trackStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMTrackVC.self)) as? DMTrackViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMTrackPresenterProtocol.self, arguments: viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMTrackPresenterProtocol.self) { r, viewInput, moduleOutput in
            return DMTrackPresenter(viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMTrackVC.self, name: String(describing: DMTrackVC.self)) { _, _ in }
    }
}
