import Foundation
import SwiftyJSON

protocol DMJobDetailModuleInput: BaseModuleInput {
    
}

protocol DMJobDetailModuleOutput: BaseModuleOutput {
    
    func presentChat(chatObject: ChatObject)
    func refreshNotificationList()
}

protocol DMJobDetailViewInput: BaseViewInput {
    var viewOutput: DMJobDetailViewOutput? { get set }
    var recruiterId: String? { get set }
    
    func configureFetch(job: Job)
    func configureJobApply()
    func reloadRows(at indexPaths: [IndexPath])
}

protocol DMJobDetailViewOutput: BaseViewOutput {
    var job: Job? { get }
    var fromTrack: Bool { get }
    var notificationId: String? { get }
    
    func didLoad()
    func fetchJob(params: [String: Any])
    func onBottomButtonTapped()
    func saveUnsave()
    func openChat(chatObject: ChatObject)
}

protocol DMJobDetailPresenterProtocol: DMJobDetailModuleInput, DMJobDetailViewOutput {
    
}
