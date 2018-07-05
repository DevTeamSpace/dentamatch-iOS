//
//  DMCalenderVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 22/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMCalenderVC: DMBaseVC, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    @IBOutlet var viewForCalender: UIView!
    @IBOutlet var bookedJobsTableView: UITableView!

    var calendar: FSCalendar?
    @IBOutlet var fulltimeJobIndicatorView: UIView!

    @IBOutlet var viewForHeader: UIView!
    @IBOutlet var monthTitleLabel: UILabel!
    @IBOutlet var noEventLabel: UILabel!

    var hiredList = [Job]()
    var selectedDayList = [Job]()

    var gregorian: NSCalendar?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)

//        if self.hiredList.count == 0 {
        getAllJobFromServer()
        // }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setup() {
        fulltimeJobIndicatorView.layer.cornerRadius = fulltimeJobIndicatorView.bounds.size.height / 2
        fulltimeJobIndicatorView.clipsToBounds = true
        title = Constants.ScreenTitleNames.calendar
        navigationItem.title = "CALENDAR"
        gregorian = NSCalendar(calendarIdentifier: .gregorian)
        monthTitleLabel.text = Date.dateToStringForFormatter(date: Date(), dateFormate: Date.dateFormatMMMMYYYY())
        monthTitleLabel.text = monthTitleLabel.text?.uppercased()
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.rightBarButtonItem = rightBarButton()
        bookedJobsTableView.separatorStyle = .none
        bookedJobsTableView.register(UINib(nibName: "SectionHeadingTableCell", bundle: nil), forCellReuseIdentifier: "SectionHeadingTableCell")
        bookedJobsTableView.register(UINib(nibName: "JobSearchResultCell", bundle: nil), forCellReuseIdentifier: "JobSearchResultCell")

        calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 311))
        calendar?.dataSource = self
        calendar?.delegate = self
        calendar?.allowsMultipleSelection = false
        calendar?.swipeToChooseGesture.isEnabled = false
        calendar?.appearance.headerMinimumDissolvedAlpha = 0
        calendar?.appearance.caseOptions = .headerUsesUpperCase
//        self.calendar?.pagingEnabled = false
//        self.calendar?.isUserInteractionEnabled = false
//        self.calendar?.showsScopeHandle = false
        calendar?.placeholderType = .none
        calendar?.calendarHeaderView.isHidden = true
        calendar?.calendarWeekdayView.isHidden = false

//        self.calendar?.calendarHeaderView.frame.size = CGSize(width: (self.calendar?.calendarHeaderView.frame.size.width)!, height: 161)
        calendar?.headerHeight = 60
        calendar?.weekdayHeight = 30
        calendar?.appearance.todayColor = UIColor.clear
        calendar?.appearance.titleTodayColor = Constants.Color.headerTitleColor
        calendar?.appearance.headerTitleFont = UIFont.fontRegular(fontSize: 12)
        calendar?.appearance.titleFont = UIFont.fontRegular(fontSize: 16)
        calendar?.appearance.weekdayFont = UIFont.fontRegular(fontSize: 16)
        calendar?.appearance.adjustsFontSizeToFitContentSize = false
        calendar?.appearance.adjustTitleIfNecessary()
        calendar?.appearance.headerTitleColor = Constants.Color.headerTitleColor
        calendar?.appearance.weekdayTextColor = Constants.Color.weekdayTextColor
        calendar?.appearance.titleDefaultColor = Constants.Color.headerTitleColor
        calendar?.appearance.selectionColor = Constants.Color.CalendarSelectionColor

//        self.calendar?.calendarWeekdayView.backgroundColor = UIColor.red
//        self.calendar?.appearance.titleOffset = CGPoint(x: 0, y: 10)
        calendar?.appearance.eventOffset = CGPoint(x: 0, y: -8)
        viewForCalender.addSubview(calendar!)
        viewForCalender.bringSubview(toFront: viewForHeader)
    }

    func getAllJobFromServer() {
        getHiredJobsFromServer(date: Date()) { _, _ in
            // debugPrint(self.hiredList.description)
            self.calendar?.reloadData()
            let fullTime = self.hiredList.filter({ (job) -> Bool in
                job.jobType == 1
            })
            if fullTime.count > 0 {
                self.fulltimeJobIndicatorView.isHidden = false
            } else {
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

    func getDayOfWeek(today: Date) -> Int {
        // 1-sunday , 4- wednesday 7- saturday
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: today)
        let weekDay = myComponents.weekday
        return weekDay!
    }

    // MARK: - Calender Methods

    func calendar(_: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let count = calculateNumberOfEvent(date: date)
        return count
    }

    func calendar(_: FSCalendar, appearance _: FSCalendarAppearance, borderRadiusFor _: Date) -> CGFloat {
        return 1.0
    }

    func calendar(_: FSCalendar, appearance _: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        return dateEventColor(date: date)
    }

    func calendar(_: FSCalendar, appearance _: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return dateEventColor(date: date)
    }

//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorsFor date: Date) -> [Any]? {
//
//        return [UIColor.red,UIColor.green,UIColor.blue]
//
//    }

    func calendar(_: FSCalendar, appearance _: FSCalendarAppearance, borderDefaultColorFor _: Date) -> UIColor? {
        return UIColor.clear
    }

    func calendar(_: FSCalendar, boundingRectWillChange _: CGRect, animated _: Bool) {
    }

    func calendar(_: FSCalendar, didSelect date: Date, at _: FSCalendarMonthPosition) {
        selectedDayList.removeAll()
        selectedDayList = dateAllEvents(date: date)
        // debugPrint(selectedDayList.description)
        if selectedDayList.count > 0 {
            noEventLabel.isHidden = true
        } else {
            noEventLabel.isHidden = false
        }
        bookedJobsTableView.reloadData()
    }

    func calendar(_: FSCalendar, didDeselect _: Date, at _: FSCalendarMonthPosition) {
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        // debugPrint("new Page  = \(calendar.currentPage)")
        monthTitleLabel.text = Date.dateToStringForFormatter(date: calendar.currentPage, dateFormate: Date.dateFormatMMMMYYYY())
        monthTitleLabel.text = monthTitleLabel.text?.uppercased()

        getHiredJobsFromServer(date: calendar.currentPage) { _, _ in
            // debugPrint(self.hiredList.description)
            self.calendar?.reloadData()
            let fullTime = self.hiredList.filter({ (job) -> Bool in
                job.jobType == 1
            })
            if fullTime.count > 0 {
                self.fulltimeJobIndicatorView.isHidden = false
            } else {
                self.fulltimeJobIndicatorView.isHidden = true
            }

            let month = Date.getMonthAndYearForm(date: calendar.currentPage)
            let currentMonth = Date.getMonthAndYearForm(date: Date())

            if month.month == currentMonth.month {
                self.calendar?.select(Date())
                self.calendar(self.calendar!, didSelect: Date(), at: FSCalendarMonthPosition.notFound)

            } else {
                let dateNew = calendar.currentPage.startOfMonth()
                self.calendar?.select(dateNew)
                self.calendar(self.calendar!, didSelect: calendar.currentPage, at: FSCalendarMonthPosition.notFound)
            }
        }
    }

    // plus button Action
    @objc func setAvailablityButtonClicked(_: Any) {
        let termsVC = UIStoryboard.calenderStoryBoard().instantiateViewController(type: DMCalendarSetAvailabillityVC.self)!
        termsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(termsVC, animated: true)
    }

    @IBAction func nextButtonClicked(_: Any) {
        let currentMonth: Date = calendar!.currentPage
        let previousMonth: Date = (gregorian?.date(byAdding: .month, value: 1, to: currentMonth, options: .matchFirst))!
        calendar?.setCurrentPage(previousMonth, animated: true)
    }

    @IBAction func previouseButtonClicked(_: Any) {
        let currentMonth: Date = calendar!.currentPage
        let previousMonth: Date = (gregorian?.date(byAdding: .month, value: -1, to: currentMonth, options: .matchFirst))!
        calendar?.setCurrentPage(previousMonth, animated: true)
    }
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }

    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth())!
    }
}
