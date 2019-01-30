import Foundation

protocol DMJobSearchResultModuleOutput: BaseModuleOutput {
    
    func showJobDetail(job: Job?, delegate: JobSavedStatusUpdateDelegate?)
    func showJobSearch(fromJobResult: Bool, delegate: SearchJobDelegate)
    func showNotifications()
}
