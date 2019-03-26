import Foundation


protocol JobSearchListScreenModuleInput: BaseModuleInput {
    
    func refreshData(_ showLoading: Bool)
    func saveOrUnsaveJob(index: Int)
}

protocol JobSearchListScreenModuleOutput: BaseModuleOutput {
    
    func showWarningView(status: Int)
    func hideWarningView()
    func openJobDetail(job: Job?, delegate: JobSavedStatusUpdateDelegate?)
    func currentJobList(jobs: [Job])
}

protocol JobSearchListScreenViewInput: BaseViewInput {
    var viewOutput: JobSearchListScreenViewOutput? { get set }
    
    func reloadData()
    func reloadAt(_ indexPaths: [IndexPath])
    func addLoaderFooter()
}

protocol JobSearchListScreenViewOutput: BaseViewOutput, JobSearchResultCellDelegate, JobSavedStatusUpdateDelegate {
    var jobs: [Job] { get }
    var totalJobs: Int { get }
    
    func didLoad()
    func refreshData(_ showLoading: Bool)
    func openJobDetail(job: Job?, delegate: JobSavedStatusUpdateDelegate?)
    func loadMore(willDisplay index: Int)
}

protocol JobSearchListScreenPresenterProtocol: JobSearchListScreenModuleInput, JobSearchListScreenViewOutput {
    
}
