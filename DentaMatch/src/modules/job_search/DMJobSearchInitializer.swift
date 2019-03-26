import Foundation
import Swinject
import SwinjectStoryboard

class DMJobSearchInitializer {
    
    class func initialize(fromJobResult: Bool, delegate: SearchJobDelegate, moduleOutput: DMJobSearchModuleOutput) -> DMJobSearchModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.jobSearchStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMJobSearchVC.self)) as? DMJobSearchViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMJobSearchPresenterProtocol.self, arguments: fromJobResult, delegate, viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMJobSearchPresenterProtocol.self) { r, fromJobResult, delegate, viewInput, moduleOutput in
            return DMJobSearchPresenter(fromJobResult: fromJobResult, delegate: delegate, viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMJobSearchVC.self, name: String(describing: DMJobSearchVC.self)) { _, _ in }
    }
}
