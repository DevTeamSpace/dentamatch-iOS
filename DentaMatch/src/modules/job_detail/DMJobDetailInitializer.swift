import Foundation
import Swinject
import SwinjectStoryboard

class DMJobDetailInitializer {
    
    class func initialize(job: Job?, recruiterId: String? = nil, notificationId: String? = nil, availableDates: [Date]? = nil, fromTrack: Bool = false, delegate: JobSavedStatusUpdateDelegate? = nil, moduleOutput: DMJobDetailModuleOutput) -> DMJobDetailModuleInput? {
        guard let viewInput = SwinjectStoryboard.create(name: Constants.StoryBoard.jobSearchStoryboard, bundle: nil, container: appContainer).instantiateViewController(withIdentifier: String(describing: DMJobDetailVC.self)) as? DMJobDetailViewInput else { return nil }
        
        let presenter = appContainer.resolve(DMJobDetailPresenterProtocol.self, arguments: job, notificationId, availableDates, fromTrack, delegate, viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        viewInput.recruiterId = recruiterId
        
        return presenter
    }
    
    class func register(for container: Container) {
        
        container.register(DMJobDetailPresenterProtocol.self) { r, job, notificationId, availableDates, fromTrack, delegate, viewInput, moduleOutput in
            return DMJobDetailPresenter(job: job, notificationId: notificationId, availableDates: availableDates, fromTrack: fromTrack, delegate: delegate, viewInput: viewInput, moduleOutput: moduleOutput)
        }
        
        container.storyboardInitCompleted(DMJobDetailVC.self, name: String(describing: DMJobDetailVC.self)) { _, _ in }
    }
}
