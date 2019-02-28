import UIKit

class DMCalenderVC: DMBaseVC, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    @IBOutlet var bookedJobsTableView: UITableView!
    
    var calendar: FSCalendar?
    private var gregorian: NSCalendar?
    private var calendarHeaderView: CalendarHeaderView?
    
    var viewOutput: DMCalendarViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        getAllJobFromServer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setup() {
        
        let calendarHeaderView = CalendarHeaderView()
        calendarHeaderView.translatesAutoresizingMaskIntoConstraints = false
        calendarHeaderView.delegate = self
        
        title = Constants.ScreenTitleNames.calendar
        navigationItem.title = "CALENDAR"
        gregorian = NSCalendar(calendarIdentifier: .gregorian)
        calendarHeaderView.monthTitleLabel.text = Date.dateToStringForFormatter(date: Date(), dateFormate: Date.dateFormatMMMMYYYY())
        calendarHeaderView.monthTitleLabel.text = calendarHeaderView.monthTitleLabel.text?.uppercased()
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        bookedJobsTableView.separatorStyle = .none
        bookedJobsTableView.register(UINib(nibName: "SectionHeadingTableCell", bundle: nil), forCellReuseIdentifier: "SectionHeadingTableCell")
        bookedJobsTableView.register(UINib(nibName: "JobSearchResultCell", bundle: nil), forCellReuseIdentifier: "JobSearchResultCell")
        bookedJobsTableView.register(UINib(nibName: EmptyJobsCalendarCell.identifier, bundle: nil), forCellReuseIdentifier: EmptyJobsCalendarCell.identifier)

        calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 311))
        calendar?.dataSource = self
        calendar?.delegate = self
        calendar?.allowsMultipleSelection = false
        calendar?.swipeToChooseGesture.isEnabled = false
        calendar?.appearance.headerMinimumDissolvedAlpha = 0
        calendar?.appearance.caseOptions = .headerUsesUpperCase
        calendar?.placeholderType = .none
        calendar?.calendarHeaderView.isHidden = true
        calendar?.calendarWeekdayView.isHidden = false
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
        calendar?.appearance.eventOffset = CGPoint(x: 0, y: -8)
        calendarHeaderView.viewForCalendar.addSubview(calendar!)
        calendarHeaderView.viewForCalendar.bringSubviewToFront(calendarHeaderView.viewForHeader)
        NotificationCenter.default.addObserver(self, selector: #selector(tabChangedAction), name: .tabChanged, object: nil)
        
        bookedJobsTableView.tableHeaderView = calendarHeaderView

        NSLayoutConstraint.activate([
            calendarHeaderView.centerXAnchor.constraint(equalTo: bookedJobsTableView.centerXAnchor),
            calendarHeaderView.widthAnchor.constraint(equalTo: bookedJobsTableView.widthAnchor),
            calendarHeaderView.topAnchor.constraint(equalTo: bookedJobsTableView.topAnchor)
        ])

        calendarHeaderView.layoutIfNeeded()
        self.calendarHeaderView = calendarHeaderView
    }
    
    @objc private func tabChangedAction(notification _: Notification){
        viewOutput?.selectedDate = nil
    }

    func getAllJobFromServer() {
        viewOutput?.getHiredJobsFromServer(date: Date(), pageChanged: false)
    }

    // MARK: - Calender Methods

    func calendar(_: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let count = viewOutput?.calculateNumberOfEvent(date: date) ?? 0
        return count
    }

    func calendar(_: FSCalendar, appearance _: FSCalendarAppearance, borderRadiusFor _: Date) -> CGFloat {
        return 1.0
    }

    func calendar(_: FSCalendar, appearance _: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        return viewOutput?.dateEventColor(date: date)
    }

    func calendar(_: FSCalendar, appearance _: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return viewOutput?.dateEventColor(date: date)
    }


    func calendar(_: FSCalendar, appearance _: FSCalendarAppearance, borderDefaultColorFor _: Date) -> UIColor? {
        return UIColor.clear
    }

    func calendar(_: FSCalendar, boundingRectWillChange _: CGRect, animated _: Bool) {
    }

    func calendar(_: FSCalendar, didSelect date: Date, at _: FSCalendarMonthPosition) {
        viewOutput?.selectedDate = date
        viewOutput?.selectedDayList.removeAll()
        let events = viewOutput?.dateAllEvents(date: date) ?? []
        viewOutput?.selectedDayList = events

        bookedJobsTableView.reloadData()
    }

    func calendar(_: FSCalendar, didDeselect _: Date, at _: FSCalendarMonthPosition) {
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        calendarHeaderView?.monthTitleLabel.text = Date.dateToStringForFormatter(date: calendar.currentPage, dateFormate: Date.dateFormatMMMMYYYY())
        calendarHeaderView?.monthTitleLabel.text = calendarHeaderView?.monthTitleLabel.text?.uppercased()
        viewOutput?.getHiredJobsFromServer(date: calendar.currentPage, pageChanged: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .tabChanged, object: nil)
    }
}

extension DMCalenderVC: DMCalendarViewInput {
    
    func fulltimeIndicatorViewHidden(_ isHidden: Bool) {
        calendarHeaderView?.fullTimeJobIndicatorView.isHidden = isHidden
    }
    
    func reloadCalendar() {
        calendar?.reloadData()
    }
    
    func calendarSelectDate(date: Date, pageChanged: Bool) {
        guard let calendar = calendar else { return }
        
        if pageChanged {
            let month = Date.getMonthAndYearForm(date: calendar.currentPage)
            let currentMonth = Date.getMonthAndYearForm(date: Date())
            
            if month.month == currentMonth.month {
                self.calendar?.select(Date())
                self.calendar(calendar, didSelect: Date(), at: FSCalendarMonthPosition.notFound)
                
            } else {
                let dateNew = calendar.currentPage.startOfMonth()
                self.calendar?.select(dateNew)
                self.calendar(calendar, didSelect: calendar.currentPage, at: FSCalendarMonthPosition.notFound)
            }
        } else {
            calendar.select(date)
            self.calendar(calendar, didSelect: date, at: FSCalendarMonthPosition.notFound)
        }
    }
}

extension DMCalenderVC: CalendarHeaderViewDelegate {
    
    func onSetAvailabilityTapped() {
        viewOutput?.openCalendar()
    }
    
    func onNextMonthButtonTapped() {
        let currentMonth: Date = calendar!.currentPage
        let previousMonth: Date = (gregorian?.date(byAdding: .month, value: 1, to: currentMonth, options: .matchFirst))!
        calendar?.setCurrentPage(previousMonth, animated: true)
    }
    
    func onPrevMonthButtonTapped() {
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
