import Foundation
import Swinject
import SwinjectStoryboard

class DMRegisterMapsInitializer {
    
    class func initialize(fromSettings: Bool, delegate: LocationAddressDelegate?, moduleOutput: DMRegisterMapsModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.registrationStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMRegisterMapsVC.self)) as? DMRegisterMapsVC
        vc?.fromSettings = fromSettings
        vc?.delegate = delegate
        vc?.moduleOutput = moduleOutput
        
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMRegisterMapsVC.self, name: String(describing: DMRegisterMapsVC.self)) { _, _ in }
    }
}
