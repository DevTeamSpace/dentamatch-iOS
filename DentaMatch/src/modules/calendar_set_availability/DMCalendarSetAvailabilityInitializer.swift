import Foundation
import Swinject
import SwinjectStoryboard

class DMCalendarSetAvailabilityInitializer {
    
    class func initialize(fromJobSelection: Bool = false, moduleOutput: DMCalendarSetAvailabilityModuleOutput) -> DMCalendarSetAvailabilityModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.calenderStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMCalendarSetAvailabillityVC.self)) as? DMCalendarSetAvailabilityViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMCalendarSetAvailabilityPresenterProtocol.self, arguments: fromJobSelection, viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMCalendarSetAvailabilityPresenterProtocol.self) { r, fromJobSelection, viewInput, moduleOutput in
            return DMCalendarSetAvailabilityPresenter(fromJobSelection: fromJobSelection, viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMCalendarSetAvailabillityVC.self, name: String(describing: DMCalendarSetAvailabillityVC.self)) { _, _ in }
    }
}
