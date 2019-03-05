import Foundation

protocol DMJobSearchResultModuleInput: BaseModuleInput {
    
}

protocol DMJobSearchResultModuleOutput: BaseModuleOutput {
    
    func showJobDetail(job: Job?, delegate: JobSavedStatusUpdateDelegate?)
    func showJobSearch(fromJobResult: Bool, delegate: SearchJobDelegate)
    func showNotifications()
}

protocol DMJobSearchResultViewInput: BaseViewInput {
    var viewOutput: DMJobSearchResultViewOutput? { get set }
    
    func showBanner(status: Int)
    func hideBanner()
    func updateBadge(count: Int)
    func refreshJobList()
    func updateMapMarkers(jobs: [Job])
}

protocol DMJobSearchResultViewOutput: BaseViewOutput, JobSearchMapScreenModuleOutput, JobSearchListScreenModuleOutput {
    
    func didLoad()
    func openJobDetail(job: Job?, delegate: JobSavedStatusUpdateDelegate?)
    func openJobSearch(fromJobResult: Bool, delegate: SearchJobDelegate)
}

protocol DMJobSearchResultPresenterProtocol: DMJobSearchResultModuleInput, DMJobSearchResultViewOutput {
    
}
