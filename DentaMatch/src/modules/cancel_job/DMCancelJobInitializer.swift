import Foundation
import Swinject
import SwinjectStoryboard

class DMCancelJobInitializer {
    
    class func initialize(job: Job?, fromApplied: Bool, delegate: CancelledJobDelegate, moduleOutput: DMCancelJobModuleOutput) -> DMCancelJobModuleInput? {
        guard let job = job,
            let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.trackStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMCancelJobVC.self)) as? DMCancelJobViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMCancelJobPresenterProtocol.self, arguments: job, fromApplied, delegate, viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMCancelJobPresenterProtocol.self) { r, job, fromApplied, delegate, viewInput, moduleOutput in
            return DMCancelJobPresenter(job: job, fromApplied: fromApplied, delegate: delegate, viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMCancelJobVC.self, name: String(describing: DMCancelJobVC.self)) { _, _ in }
    }
}
