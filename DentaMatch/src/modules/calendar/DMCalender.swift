import Foundation

protocol DMCalendarModuleInput: BaseModuleInput {
    
}

protocol DMCalendarModuleOutput: BaseModuleOutput {
    
    func showCalendar()
    func showJobDetail(job: Job?)
    func showCancelJob(job: Job?, fromApplied: Bool, delegate: CancelledJobDelegate)
}

protocol DMCalendarViewInput: BaseViewInput {
    var viewOutput: DMCalendarViewOutput? { get set }
    
    func fulltimeIndicatorViewHidden(_ isHidden: Bool)
    func reloadCalendar()
    func calendarSelectDate(date: Date, pageChanged: Bool)
}

protocol DMCalendarViewOutput: BaseViewOutput {
    var hiredList: [Job] { get set }
    var selectedDayList: [Job] { get set }
    var selectedDate: Date? { get set }
    
    func didLoad()
    func getHiredJobsFromServer(date: Date, pageChanged: Bool)
    func openCalendar()
    func openJobDetail(index: Int)
    func openCancelJob(job: Job, fromApplied: Bool, delegate: CancelledJobDelegate)
    func calculateNumberOfEvent(date: Date) -> Int
    func dateEventColor(date: Date) -> [UIColor]
    func dateAllEvents(date: Date) -> [Job]
}

protocol DMCalendarPresenterProtocol: DMCalendarModuleInput, DMCalendarViewOutput {
    
}

