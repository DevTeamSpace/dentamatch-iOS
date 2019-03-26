import Foundation
import Swinject
import SwinjectStoryboard

class DMSettingsInitializer {
    
    class func initialize(moduleOutput: DMSettingsModuleOutput) -> DMSettingsModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.dashboardStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMSettingVC.self)) as? DMSettingsViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMSettingsPresenterProtocol.self, arguments: viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMSettingsPresenterProtocol.self) { r, viewInput, moduleOutput in
            return DMSettingsPresenter(viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMSettingVC.self, name: String(describing: DMSettingVC.self)) { _, _ in }
    }
}
