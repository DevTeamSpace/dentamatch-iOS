import Foundation
import Swinject
import SwinjectStoryboard

class DMSettingsInitializer {
    
    class func initialize(moduleOutput: DMSettingsModuleOutput) -> UIViewController? {
        
        let vc = SwinjectStoryboard.create(name: Constants.StoryBoard.dashboardStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMSettingVC.self)) as? DMSettingVC
        vc?.moduleOutput = moduleOutput
        
        return vc
    }
    
    class func register(for container: Container) {
        
        container.storyboardInitCompleted(DMSettingVC.self, name: String(describing: DMSettingVC.self)) { _, _ in }
    }
}
