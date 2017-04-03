//
//  DMCalenderVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 22/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import FSCalendar

class DMCalenderVC: DMBaseVC,FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance {
    @IBOutlet weak var viewForCalender: UIView!
    @IBOutlet weak var bookedJobsTableView: UITableView!

    var calendar:FSCalendar?
    @IBOutlet weak var fulltimeJobIndicatorView: UIView!
    
    @IBOutlet weak var viewForHeader: UIView!
    @IBOutlet weak var monthTitleLabel: UILabel!
    @IBOutlet weak var noEventLabel: UILabel!
    
    var hiredList  = [Job]()
    var selectedDayList  = [Job]()

    var gregorian:NSCalendar?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        if self.hiredList.count == 0 {
            self.getAllJobFromServer()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        self.fulltimeJobIndicatorView.layer.cornerRadius = fulltimeJobIndicatorView.bounds.size.height/2
        self.fulltimeJobIndicatorView.clipsToBounds = true
        self.title = Constants.ScreenTitleNames.calendar
        self.navigationItem.title = "CALENDAR"
        gregorian = NSCalendar(calendarIdentifier: .gregorian)
        self.monthTitleLabel.text = Date.dateToStringForFormatter(date: Date(), dateFormate: Date.dateFormatMMMMYYYY())
        self.monthTitleLabel.text = self.monthTitleLabel.text?.uppercased()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.rightBarButtonItem = self.rightBarButton()
        self.bookedJobsTableView.separatorStyle = .none
        self.bookedJobsTableView.register(UINib(nibName: "SectionHeadingTableCell", bundle: nil), forCellReuseIdentifier: "SectionHeadingTableCell")
        self.bookedJobsTableView.register(UINib(nibName: "JobSearchResultCell", bundle: nil), forCellReuseIdentifier: "JobSearchResultCell")


        self.calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 311))
        self.calendar?.dataSource = self;
        self.calendar?.delegate = self;
        self.calendar?.allowsMultipleSelection = false
        self.calendar?.swipeToChooseGesture.isEnabled = false
        self.calendar?.appearance.headerMinimumDissolvedAlpha = 0
        self.calendar?.appearance.caseOptions = .headerUsesUpperCase
//        self.calendar?.pagingEnabled = false
//        self.calendar?.isUserInteractionEnabled = false
//        self.calendar?.showsScopeHandle = false
        self.calendar?.placeholderType = .none
        self.calendar?.calendarHeaderView.isHidden = true
        self.calendar?.calendarWeekdayView.isHidden = false
        
//        self.calendar?.calendarHeaderView.frame.size = CGSize(width: (self.calendar?.calendarHeaderView.frame.size.width)!, height: 161)
        self.calendar?.headerHeight = 60
        self.calendar?.weekdayHeight = 30
        self.calendar?.appearance.todayColor = UIColor.clear
        self.calendar?.appearance.titleTodayColor = Constants.Color.headerTitleColor
        self.calendar?.appearance.headerTitleFont = UIFont.fontRegular(fontSize: 12)
        self.calendar?.appearance.titleFont = UIFont.fontRegular(fontSize: 16)
        self.calendar?.appearance.weekdayFont = UIFont.fontRegular(fontSize: 16)
        self.calendar?.appearance.adjustsFontSizeToFitContentSize = false
        self.calendar?.appearance.adjustTitleIfNecessary()
        self.calendar?.appearance.headerTitleColor = Constants.Color.headerTitleColor
        self.calendar?.appearance.weekdayTextColor = Constants.Color.weekdayTextColor
        self.calendar?.appearance.titleDefaultColor = Constants.Color.headerTitleColor
        self.calendar?.appearance.selectionColor = Constants.Color.CalendarSelectionColor
        
//        self.calendar?.calendarWeekdayView.backgroundColor = UIColor.red
//        self.calendar?.appearance.titleOffset = CGPoint(x: 0, y: 10)
        self.calendar?.appearance.eventOffset = CGPoint(x: 0, y: -8)
        self.viewForCalender.addSubview(self.calendar!)
        self.viewForCalender.bringSubview(toFront: self.viewForHeader)


       
    }
    
    func getAllJobFromServer() {
        self.getHiredJobsFromServer(date:Date()) { (response, error) in
            debugPrint(self.hiredList.description)
            self.calendar?.reloadData()
            let fullTime  = self.hiredList.filter({ (job) -> Bool in
                job.jobType == 1
            })
            if fullTime.count > 0 {
                self.fulltimeJobIndicatorView.isHidden = false
            }else{
                self.fulltimeJobIndicatorView.isHidden = true
            }
            
            self.calendar?.select(Date())
            self.calendar(self.calendar!, didSelect: Date(), at: FSCalendarMonthPosition.notFound)
        }
    }
    
    
    func rightBarButton() -> UIBarButtonItem {
        let customButton = UIButton(type: .system)
        customButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        customButton.titleLabel?.font = UIFont.designFont(fontSize: 30)
        customButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        customButton.setImage(UIImage(named: "plusSymbol"), for: .normal)
        customButton.addTarget(self, action: #selector(setAvailablityButtonClicked(_:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: customButton)
        return barButton
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func calculateNumberOfEvent(date:Date) -> Int {
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
            return  (newJob.isTuesday == 1 && eventDate <= dateToday)
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
//        for temp in dayTempTime {
//            
//            let tempNew = temp.filter({ (dateString) -> Bool in
//                (dateString.jobDate == Date.dateToString(date: date))
//            })
//            if tempNew.count > 0 {
//                eventcount = eventcount + 1
//                break
//            }
//            
//            
//        }
        
//        let tempDay = dayTempTime.filter { (newJob) -> Bool in
//            (newJob.tempJobDates.contains(where: { (objDate) -> Bool in
//                (objDate.jobDate == Date.dateToString(date: Date()))
//            }))
//        }
        
//        if tempDay.count > 0 {
//            eventcount = eventcount + 1
//        }
        return eventcount
        
    }
    
    
    
    
    func dateEventColor(date:Date) -> [UIColor] {
        
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
                return  (newJob.isSunday == 1 && eventDate <= dateToday)
            }
            if sundayJob.count > 0 {
                color.append(Constants.Color.partTimeEventColor)
            }
            
        case 2:
            let mondayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return  (newJob.isMonday == 1 && eventDate <= dateToday)
            }
            if mondayJob.count > 0 {
                color.append(Constants.Color.partTimeEventColor)
            }
            
        case 3:
            let tuesdayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return  (newJob.isTuesday == 1 && eventDate <= dateToday)
            }
            if tuesdayJob.count > 0 {
                color.append(Constants.Color.partTimeEventColor)
            }
        case 4:
            let wednesdayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return  (newJob.isWednesday == 1 && eventDate <= dateToday)
            }
            if wednesdayJob.count > 0 {
                color.append(Constants.Color.partTimeEventColor)
            }
        case 5:
            let thursdayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return  (newJob.isThursday == 1 && eventDate <= dateToday)
            }
            if thursdayJob.count > 0 {
                color.append(Constants.Color.partTimeEventColor)
            }
        case 6:
            let firdayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return  (newJob.isFriday == 1 && eventDate <= dateToday)
            }
            if firdayJob.count > 0 {
                color.append(Constants.Color.partTimeEventColor)
            }
        case 7:
            let saturdayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return  (newJob.isSaturday == 1 && eventDate <= dateToday)
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
//        for temp in dayTempTime {
//            
//            let tempNew = temp.tempJobDates.filter({ (dateString) -> Bool in
//                (dateString.jobDate == Date.dateToString(date: date))
//            })
//            if tempNew.count > 0 {
//                color.append(Constants.Color.tempTimeEventColor)
//            }
//            
//        }
        
        return color
        
    }
    
    
    
    func dateAllEvents(date:Date) -> [Job] {
        
//        let dayFullTime = hiredList.filter { (newJob) -> Bool in
//            (newJob.jobType == 1)
//        }

        
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
                return  (newJob.isSunday == 1 && eventDate <= dateToday)
            }
            if sundayJob.count > 0 {
                todayAllEvent.append(contentsOf: sundayJob)
            }
            
        case 2:
            let mondayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return  (newJob.isMonday == 1 && eventDate <= dateToday)
            }
            if mondayJob.count > 0 {
                todayAllEvent.append(contentsOf: mondayJob)
            }
            
        case 3:
            let tuesdayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return  (newJob.isTuesday == 1 && eventDate <= dateToday)
            }
            if tuesdayJob.count > 0 {
                todayAllEvent.append(contentsOf: tuesdayJob)
            }
        case 4:
            let wednesdayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return  (newJob.isWednesday == 1 && eventDate <= dateToday)
            }
            if wednesdayJob.count > 0 {
                todayAllEvent.append(contentsOf: wednesdayJob)
            }
        case 5:
            let thursdayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return  (newJob.isThursday == 1 && eventDate <= dateToday)
            }
            if thursdayJob.count > 0 {
                todayAllEvent.append(contentsOf: thursdayJob)
            }
        case 6:
            let firdayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return  (newJob.isFriday == 1 && eventDate <= dateToday)
            }
            if firdayJob.count > 0 {
                todayAllEvent.append(contentsOf: firdayJob)
            }
        case 7:
            let saturdayJob = dayPartTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.jobDate)
                return  (newJob.isSaturday == 1 && eventDate <= dateToday)
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
//        for temp in dayTempTime {
        
//            let tempNew = temp.tempJobDates.filter({ (dateString) -> Bool in
//                (dateString.jobDate == Date.dateToString(date: date))
//            })
            let tempJobs = dayTempTime.filter { (newJob) -> Bool in
                let eventDate = Date.stringToDate(dateString: newJob.tempjobDate)
                return (eventDate == dateToday)
            }
            if tempJobs.count > 0 {
//                todayAllEvent.append(temp)
                todayAllEvent.append(contentsOf: tempJobs)

            }
        
//        }
        
        return todayAllEvent
        
    }
    
    func getDayOfWeek(today:Date)->Int {
        //1-sunday , 4- wednesday 7- saturday
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: today)
        let weekDay = myComponents.weekday
        return weekDay!
    }

    //MARK:- Calender Methods 
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let count = calculateNumberOfEvent(date: date)
        return count
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        return 1.0
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        return dateEventColor(date: date)
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return dateEventColor(date: date)
    }
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorsFor date: Date) -> [Any]? {
//        
//        return [UIColor.red,UIColor.green,UIColor.blue]
//        
//    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        return UIColor.clear
    }
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDayList.removeAll()
        selectedDayList = dateAllEvents(date: date)
        debugPrint(selectedDayList.description)
        if selectedDayList.count > 0 {
            self.noEventLabel.isHidden = true
        }else {
            self.noEventLabel.isHidden = false
        }
        bookedJobsTableView.reloadData()
        

    }
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        debugPrint("new Page  = \(calendar.currentPage)")
        self.monthTitleLabel.text = Date.dateToStringForFormatter(date: calendar.currentPage, dateFormate: Date.dateFormatMMMMYYYY())
        self.monthTitleLabel.text = self.monthTitleLabel.text?.uppercased()
        
        self.getHiredJobsFromServer(date: calendar.currentPage) { (response, error) in
            debugPrint(self.hiredList.description)
            self.calendar?.reloadData()
            let fullTime  = self.hiredList.filter({ (job) -> Bool in
                job.jobType == 1
            })
            if fullTime.count > 0 {
                self.fulltimeJobIndicatorView.isHidden = false
            }else{
                self.fulltimeJobIndicatorView.isHidden = true
            }
            
             let month =  Date.getMonthAndYearForm(date: calendar.currentPage)
            let currentMonth = Date.getMonthAndYearForm(date: Date())
            
            if (month.month == currentMonth.month) {
                self.calendar?.select(Date())
                self.calendar(self.calendar!, didSelect: Date(), at: FSCalendarMonthPosition.notFound)

            }else{
                let dateNew = calendar.currentPage.startOfMonth()
                self.calendar?.select(dateNew)
                self.calendar(self.calendar!, didSelect: calendar.currentPage, at: FSCalendarMonthPosition.notFound)

            }
            
        }

    }

    
    
    
    //pluse button Action
    func setAvailablityButtonClicked(_ sender: Any) {
        let termsVC = UIStoryboard.calenderStoryBoard().instantiateViewController(type: DMCalendarSetAvailabillityVC.self)!
        termsVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(termsVC, animated: true)
    }
    @IBAction func nextButtonClicked(_ sender: Any) {
        let currentMonth:Date = self.calendar!.currentPage
        let previousMonth:Date = (self.gregorian?.date(byAdding: .month, value: 1, to: currentMonth, options: .matchFirst))!
//        self.monthTitleLabel.text = Date.dateToStringForFormatter(date: previousMonth, dateFormate: Date.dateFormatMMMMYYYY())

//        let dateData = Date.getMonthAndYearForm(date: Date())
//        self.getHiredJobsFromServer(date:previousMonth) { (response, error) in
//            debugPrint(self.hiredList.description)
//            self.calendar?.reloadData()
//            let fullTime  = self.hiredList.filter({ (job) -> Bool in
//                job.jobType == 1
//            })
//            if fullTime.count > 0 {
//                self.fulltimeJobIndicatorView.isHidden = false
//            }else{
//                self.fulltimeJobIndicatorView.isHidden = true
//            }
//            self.calendar?.setCurrentPage(previousMonth, animated: true)
//
//        }
        self.calendar?.setCurrentPage(previousMonth, animated: true)

    }
    @IBAction func previouseButtonClicked(_ sender: Any) {
        let currentMonth:Date = self.calendar!.currentPage
        let previousMonth:Date = (self.gregorian?.date(byAdding: .month, value: -1, to: currentMonth, options: .matchFirst))!
        
        self.calendar?.setCurrentPage(previousMonth, animated: true)

    }

    
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}

