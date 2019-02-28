import Foundation
import SwiftyJSON

final class DMCalendarPresenter: DMCalendarPresenterProtocol {
    
    unowned let viewInput: DMCalendarViewInput
    unowned let moduleOutput: DMCalendarModuleOutput
    
    init(viewInput: DMCalendarViewInput, moduleOutput: DMCalendarModuleOutput) {
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
    
    var hiredList = [Job]()
    var selectedDayList = [Job]()
    var selectedDate: Date?
}

extension DMCalendarPresenter: DMCalendarModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMCalendarPresenter: DMCalendarViewOutput {
    
    func didLoad() {
        
        
    }
    
    func openCalendar() {
        moduleOutput.showCalendar()
    }
    
    func openJobDetail(index: Int) {
        moduleOutput.showJobDetail(job: selectedDayList[index])
    }
    
    func openCancelJob(job: Job, fromApplied: Bool, delegate: CancelledJobDelegate) {
        moduleOutput.showCancelJob(job: job, fromApplied: fromApplied, delegate: delegate)
    }
    
    func getHiredJobsFromServer(date: Date, pageChanged: Bool) {
        
        guard let gregorian = NSCalendar(calendarIdentifier: .gregorian) else { return }
        
        let date5 = gregorian.fs_firstDay(ofMonth: date)
        let date2 = gregorian.fs_lastDay(ofMonth: date)
        let strStartDate = Date.dateToString(date: date5!)
        let strEndDate = Date.dateToString(date: date2!)
        
        var param = [String: Any]()
        param["jobStartDate"] = strStartDate
        param["jobEndDate"] = strEndDate
        
        viewInput.showLoading()
        APIManager.apiPost(serviceName: Constants.API.getHiredJobs, parameters: param) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            if !response[Constants.ServerKey.status].boolValue, response[Constants.ServerKey.statusCode].intValue != 201 {
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
            
            self?.hiredList.removeAll()
            
            let resultDic = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
            for calObj in resultDic {
                let hiredObj = Job(forCalendarjob: calObj)
                self?.hiredList.append(hiredObj)
            }
            
            let fullTime = self?.hiredList.filter({ (job) -> Bool in
                job.jobType == 1
            })
            
            self?.viewInput.fulltimeIndicatorViewHidden(fullTime?.count != 0)
            self?.viewInput.reloadCalendar()
            self?.viewInput.calendarSelectDate(date: self?.selectedDate ?? Date(), pageChanged: pageChanged)
        }
    }
    
    func calculateNumberOfEvent(date: Date) -> Int {
        let dayPartTime = hiredList.filter { (newJob) -> Bool in
            (newJob.jobType == 2)
        }
        
        let dateStrToday = Date.dateToString(date: date)
        let dateToday = Date.stringToDate(dateString: dateStrToday)
        
        var eventcount = 0
        switch getDayOfWeek(today: date) {
        case 1:
            let sundayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return (newJob.isSunday == 1 && eventDate <= dateToday)
            }
            if sundayJob.count > 0 {
                eventcount = eventcount + 1
            }
            
        case 2:
            let mondayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return (newJob.isMonday == 1 && eventDate <= dateToday)
            }
            if mondayJob.count > 0 {
                eventcount = eventcount + 1
            }
            
        case 3:
            let tuesdayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return (newJob.isTuesday == 1 && eventDate <= dateToday)
            }
            if tuesdayJob.count > 0 {
                eventcount = eventcount + 1
            }
        case 4:
            let wednesdayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return (newJob.isWednesday == 1 && eventDate <= dateToday)
            }
            if wednesdayJob.count > 0 {
                eventcount = eventcount + 1
            }
        case 5:
            let thursdayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return (newJob.isThursday == 1 && eventDate <= dateToday)
            }
            if thursdayJob.count > 0 {
                eventcount = eventcount + 1
            }
        case 6:
            let firdayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return (newJob.isFriday == 1 && eventDate <= dateToday)
            }
            if firdayJob.count > 0 {
                eventcount = eventcount + 1
            }
        case 7:
            let saturdayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return (newJob.isSaturday == 1 && eventDate <= dateToday)
            }
            if saturdayJob.count > 0 {
                eventcount = eventcount + 1
            }
            
        default:
            break
        }
        
        let dayTempTime = hiredList.filter { (newJob) -> Bool in
            (newJob.jobType == 3)
        }
        
        let tempJobs = dayTempTime.filter { (newJob) -> Bool in
            let eventDate = Date.stringToDate(dateString: newJob.tempjobDate)
            return (eventDate == dateToday)
        }
        
        if tempJobs.count > 0 {
            eventcount = eventcount + 1
        }
        return eventcount
    }
    
    func dateEventColor(date: Date) -> [UIColor] {
        let dayPartTime = hiredList.filter { (newJob) -> Bool in
            (newJob.jobType == 2)
        }
        let dateStrToday = Date.dateToString(date: date)
        let dateToday = Date.stringToDate(dateString: dateStrToday)
        
        var color = [UIColor]()
        switch getDayOfWeek(today: date) {
        case 1:
            let sundayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return (newJob.isSunday == 1 && eventDate <= dateToday)
            }
            if sundayJob.count > 0 {
                color.append(Constants.Color.partTimeEventColor)
            }
            
        case 2:
            let mondayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return (newJob.isMonday == 1 && eventDate <= dateToday)
            }
            if mondayJob.count > 0 {
                color.append(Constants.Color.partTimeEventColor)
            }
            
        case 3:
            let tuesdayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return (newJob.isTuesday == 1 && eventDate <= dateToday)
            }
            if tuesdayJob.count > 0 {
                color.append(Constants.Color.partTimeEventColor)
            }
        case 4:
            let wednesdayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return (newJob.isWednesday == 1 && eventDate <= dateToday)
            }
            if wednesdayJob.count > 0 {
                color.append(Constants.Color.partTimeEventColor)
            }
        case 5:
            let thursdayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return (newJob.isThursday == 1 && eventDate <= dateToday)
            }
            if thursdayJob.count > 0 {
                color.append(Constants.Color.partTimeEventColor)
            }
        case 6:
            let firdayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return (newJob.isFriday == 1 && eventDate <= dateToday)
            }
            if firdayJob.count > 0 {
                color.append(Constants.Color.partTimeEventColor)
            }
        case 7:
            let saturdayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return (newJob.isSaturday == 1 && eventDate <= dateToday)
            }
            if saturdayJob.count > 0 {
                color.append(Constants.Color.partTimeEventColor)
                break
            }
            
        default:
            break
        }
        
        let dayTempTime = hiredList.filter { (newJob) -> Bool in
            (newJob.jobType == 3)
        }
        
        let tempJobs = dayTempTime.filter { (newJob) -> Bool in
            let eventDate = Date.stringToDate(dateString: newJob.tempjobDate)
            return (eventDate == dateToday)
        }
        
        if tempJobs.count > 0 {
            color.append(Constants.Color.tempTimeEventColor)
        }
        
        return color
    }
    
    func dateAllEvents(date: Date) -> [Job] {
        let dayPartTime = hiredList.filter { (newJob) -> Bool in
            (newJob.jobType == 2)
        }
        var todayAllEvent = [Job]()
        
        let dateStrToday = Date.dateToString(date: date)
        let dateToday = Date.stringToDate(dateString: dateStrToday)
        
        //        todayAllEvent.append(contentsOf: dayFullTime)
        switch getDayOfWeek(today: date) {
        case 1:
            let sundayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return (newJob.isSunday == 1 && eventDate <= dateToday)
            }
            if sundayJob.count > 0 {
                todayAllEvent.append(contentsOf: sundayJob)
            }
            
        case 2:
            let mondayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return (newJob.isMonday == 1 && eventDate <= dateToday)
            }
            if mondayJob.count > 0 {
                todayAllEvent.append(contentsOf: mondayJob)
            }
            
        case 3:
            let tuesdayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return (newJob.isTuesday == 1 && eventDate <= dateToday)
            }
            if tuesdayJob.count > 0 {
                todayAllEvent.append(contentsOf: tuesdayJob)
            }
        case 4:
            let wednesdayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return (newJob.isWednesday == 1 && eventDate <= dateToday)
            }
            if wednesdayJob.count > 0 {
                todayAllEvent.append(contentsOf: wednesdayJob)
            }
        case 5:
            let thursdayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return (newJob.isThursday == 1 && eventDate <= dateToday)
            }
            if thursdayJob.count > 0 {
                todayAllEvent.append(contentsOf: thursdayJob)
            }
        case 6:
            let firdayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return (newJob.isFriday == 1 && eventDate <= dateToday)
            }
            if firdayJob.count > 0 {
                todayAllEvent.append(contentsOf: firdayJob)
            }
        case 7:
            let saturdayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return (newJob.isSaturday == 1 && eventDate <= dateToday)
            }
            if saturdayJob.count > 0 {
                todayAllEvent.append(contentsOf: saturdayJob)
            }
            
        default:
            break
        }
        
        let dayTempTime = hiredList.filter { (newJob) -> Bool in
            (newJob.jobType == 3)
        }
        let tempJobs = dayTempTime.filter { (newJob) -> Bool in
            let eventDate = Date.stringToDate(dateString: newJob.tempjobDate)
            return (eventDate == dateToday)
        }
        if tempJobs.count > 0 {
            todayAllEvent.append(contentsOf: tempJobs)
        }
        
        return todayAllEvent
    }
}

extension DMCalendarPresenter {
    
    private func getDayOfWeek(today: Date) -> Int {
        // 1-sunday , 4- wednesday 7- saturday
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: today)
        let weekDay = myComponents.weekday
        return weekDay!
    }
}
