import Foundation
import SwiftyJSON

protocol DMJobDetailModuleInput: BaseModuleInput {
    
}

protocol DMJobDetailModuleOutput: BaseModuleOutput {
    
}

protocol DMJobDetailViewInput: BaseViewInput {
    var viewOutput: DMJobDetailViewOutput? { get set }
    
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
}

protocol DMJobDetailPresenterProtocol: DMJobDetailModuleInput, DMJobDetailViewOutput {
    
}
