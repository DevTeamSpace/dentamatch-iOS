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
    
    func reloadAt(_ indexPaths: [IndexPath])
    func showBanner(status: Int)
    func hideBanner()
    func configureTableView(jobsCount: Int, totalJobsCount: Int, status: Bool)
    func updateBadge(count: Int)
}

protocol DMJobSearchResultViewOutput: BaseViewOutput {
    var jobs: [Job] { get set }
    var totalJobsFromServer: Int { get set }
    var jobsPageNo: Int { get set }
    var bannerStatus: Int { get set }
    
    func openNotifications()
    func saveOrUnsaveJob(index: Int)
    func openJobDetail(job: Job?, delegate: JobSavedStatusUpdateDelegate?)
    func openJobSearch(fromJobResult: Bool, delegate: SearchJobDelegate)
    func fetchSearchResult(params: [String: Any])
    func getUnreadedNotifications()
}

protocol DMJobSearchResultPresenterProtocol: DMJobSearchResultModuleInput, DMJobSearchResultViewOutput {
    
}
