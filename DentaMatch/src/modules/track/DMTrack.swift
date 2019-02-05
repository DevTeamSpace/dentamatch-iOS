import Foundation

protocol DMTrackModuleInput: BaseModuleInput {
    
}

protocol DMTrackModuleOutput: BaseModuleOutput {
    
    func showJobDetails(job: Job?, delegate: JobSavedStatusUpdateDelegate)
    func showCancelJob(job: Job?, fromApplied: Bool, delegate: CancelledJobDelegate)
}

protocol DMTrackViewInput: BaseViewInput {
    var viewOutput: DMTrackViewOutput? { get set }
    
    func reloadData()
    func configureEmptyView(isHidden: Bool, message: String?)
    func addLoadingCell(to type: PTRType)
}

protocol DMTrackViewOutput: BaseViewOutput {
    var savedJobs: [Job] { get }
    var appliedJobs:  [Job] { get }
    var shortListedJobs: [Job] { get }
    
    func didLoad()
    func refreshData(type: PTRType)
    func switchToType(_ type: PTRType)
    func openJobDetails(index: Int, type: PTRType, delegate: JobSavedStatusUpdateDelegate)
    func openCancelJob(index: Int, type: PTRType, fromApplied: Bool, delegate: CancelledJobDelegate)
    func jobUpdate(_ job: Job)
    func jobApplied()
    func saveUnsaveJob(status: Int, index: Int)
    func cancelledJob(_ job: Job, fromApplied: Bool)
    func callLoadMore(type: Int)
}

protocol DMTrackPresenterProtocol: DMTrackModuleInput, DMTrackViewOutput {
    
}
