import Foundation

protocol DMTrackModuleOutput: BaseModuleOutput {
    
    func showJobDetails(job: Job?, delegate: JobSavedStatusUpdateDelegate)
    func showCancelJob(job: Job?, fromApplied: Bool, delegate: CancelledJobDelegate)
}
