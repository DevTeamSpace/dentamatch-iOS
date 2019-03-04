import Foundation
import Swinject
import SwinjectStoryboard

class DMJobDetailInitializer {
    
    class func initialize(job: Job?, recruiterId: String? = nil, fromTrack: Bool = false, delegate: JobSavedStatusUpdateDelegate? = nil, moduleOutput: DMJobDetailModuleOutput) -> DMJobDetailModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.jobSearchStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMJobDetailVC.self)) as? DMJobDetailViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMJobDetailPresenterProtocol.self, arguments: job, fromTrack, delegate, viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        viewInput.recruiterId = recruiterId
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMJobDetailPresenterProtocol.self) { r, job, fromTrack, delegate, viewInput, moduleOutput in
            return DMJobDetailPresenter(job: job, fromTrack: fromTrack, delegate: delegate, viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMJobDetailVC.self, name: String(describing: DMJobDetailVC.self)) { _, _ in }
    }
}
