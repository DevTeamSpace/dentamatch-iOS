import Foundation
import SwiftyJSON

protocol DMJobDetailModuleInput: BaseModuleInput {
    
}

protocol DMJobDetailModuleOutput: BaseModuleOutput {
    
    func presentChat(chatObject: ChatObject)
}

protocol DMJobDetailViewInput: BaseViewInput {
    var viewOutput: DMJobDetailViewOutput? { get set }
    var recruiterId: String? { get set }
    
    func configureView(job: Job?, fromTrack: Bool, delegate: JobSavedStatusUpdateDelegate?)
    func configureFetch(job: Job)
    func configureJobApply(response: JSON)
    func configureSaveUnsave(status: Int)
}

protocol DMJobDetailViewOutput: BaseViewOutput {
    
    func didLoad()
    func fetchJob(params: [String: Any])
    func applyJob(params: [String: Any])
    func saveUnsave(job: Job?)
    func openChat(chatObject: ChatObject)
}

protocol DMJobDetailPresenterProtocol: DMJobDetailModuleInput, DMJobDetailViewOutput {
    
}
