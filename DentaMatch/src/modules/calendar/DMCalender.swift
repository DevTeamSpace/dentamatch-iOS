import Foundation

protocol DMCalendarModuleOutput: BaseModuleOutput {
    
    func showCalendar()
    func showJobDetail(job: Job?)
    func showCancelJob(job: Job?, fromApplied: Bool, delegate: CancelledJobDelegate)
}
