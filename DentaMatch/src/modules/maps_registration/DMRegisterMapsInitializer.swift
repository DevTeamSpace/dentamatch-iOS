import Foundation
import Swinject
import SwinjectStoryboard

class DMRegisterMapsInitializer {
    
    class func initialize(fromSettings: Bool, delegate: LocationAddressDelegate?, moduleOutput: DMRegisterMapsModuleOutput) -> DMRegisterMapsModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.registrationStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMRegisterMapsVC.self)) as? DMRegisterMapsViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMRegisterMapsPresenterProtocol.self, arguments: fromSettings, delegate, viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMRegisterMapsPresenterProtocol.self) { r, fromSettings, delegate, viewInput, moduleOutput in
            return DMRegisterMapsPresenter(fromSettings: fromSettings,
                                           delegate: delegate,
                                           viewInput: viewInput,
                                           moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMRegisterMapsVC.self, name: String(describing: DMRegisterMapsVC.self)) { _, _ in }
    }
}

