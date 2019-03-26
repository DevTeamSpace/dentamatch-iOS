import Foundation
import Swinject
import SwinjectStoryboard

final class DMCalendarInitializer {
    
    class func initialize(moduleOutput: DMCalendarModuleOutput) -> DMCalendarModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.calenderStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMCalenderVC.self)) as? DMCalendarViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMCalendarPresenterProtocol.self, arguments: viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMCalendarPresenterProtocol.self) { r, viewInput, moduleOutput in
            return DMCalendarPresenter(viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMCalenderVC.self, name: String(describing: DMCalenderVC.self)) { _, _ in }
    }
}
