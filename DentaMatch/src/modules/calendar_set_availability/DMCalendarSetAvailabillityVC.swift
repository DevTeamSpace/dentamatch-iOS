import UIKit
import SwiftyJSON

class DMCalendarSetAvailabillityVC: DMBaseVC {
    @IBOutlet var calenderTableView: UITableView!
    var isPartTimeDayShow: Bool = false
    var isTemporyAvail: Bool = false
    var fromJobSelection = false

    var isJobTypeFullTime: String! = "0"
    var isJobTypePartTime: String! = "0"
    var availablitytModel: UserAvailability? = UserAvailability()
    var gregorian: NSCalendar?
    var fromRoot = false
    
    var viewOutput: DMCalendarSetAvailabilityViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewOutput?.didLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if fromJobSelection {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setup() {
        title = Constants.ScreenTitleNames.setAvailibility
        gregorian = NSCalendar(calendarIdentifier: .gregorian)
        calenderTableView.rowHeight = UITableView.automaticDimension
        calenderTableView.separatorStyle = .none
        calenderTableView.register(UINib(nibName: "JobSearchTypeCell", bundle: nil), forCellReuseIdentifier: "JobSearchTypeCell")
        calenderTableView.register(UINib(nibName: "JobSearchPartTimeCell", bundle: nil), forCellReuseIdentifier: "JobSearchPartTimeCell")
        calenderTableView.register(UINib(nibName: "TemporyJobCalenderCell", bundle: nil), forCellReuseIdentifier: "TemporyJobCalenderCell")
        calenderTableView.register(UINib(nibName: "TemporyJobCell", bundle: nil), forCellReuseIdentifier: "TemporyJobCell")

        navigationItem.rightBarButtonItem = rightBarButton()
    }

    // By Default set all days as available
    func autoFillData() {
        isPartTimeDayShow = true
        isTemporyAvail = true
        availablitytModel?.isParttime = true
        availablitytModel?.isFulltime = true

        availablitytModel?.isParttimeMonday = true
        availablitytModel?.isParttimeTuesday = true
        availablitytModel?.isParttimeWednesday = true
        availablitytModel?.isParttimeThursday = true
        availablitytModel?.isParttimeFriday = true
        availablitytModel?.isParttimeSaturday = true
        availablitytModel?.isParttimeSunday = true
        isJobTypeFullTime = "1"
        isJobTypePartTime = "1"
        getDateForMonths(months: 3)
        calenderTableView.reloadData()
    }

    func getDateForMonths(months: Int) {
        let dateStrToday = Date.dateToStringWithUTC(date: Date())
        var dateToday = Date.stringToDateWithUTC(dateString: dateStrToday)

        let endDate = Calendar.current.date(byAdding: DateComponents(month: months), to: dateToday)! //this create date with previous month for date.
        availablitytModel?.tempJobDates.removeAll()
        availablitytModel?.tempJobDates.append(dateStrToday)

        while dateToday <= endDate {
            dateToday = Calendar.current.date(byAdding: DateComponents(day: 1), to: dateToday)!
            // print(dateToday)
            availablitytModel?.tempJobDates.append(Date.dateToString(date: dateToday))
        }
    }

    func rightBarButton() -> UIBarButtonItem {
        let customButton = UIButton(type: .system)
        customButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        customButton.titleLabel?.font = UIFont.fontRegular(fontSize: 16)
        customButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        customButton.setTitle("Save", for: .normal)
        customButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: customButton)
        return barButton
    }

    @objc func saveButtonPressed() {

        if !checkValidations() {
            return
        }

        setMyAvailabilityOnServer()
    }

    func checkValidations() -> Bool {
        if isPartTimeDayShow == true {
            if (availablitytModel?.isParttimeMonday)! || (availablitytModel?.isParttimeTuesday)! || (availablitytModel?.isParttimeWednesday)! || (availablitytModel?.isParttimeThursday)! || (availablitytModel?.isParttimeFriday)! || (availablitytModel?.isParttimeSaturday)! || (availablitytModel?.isParttimeSunday)! {
                // debugPrint("Is part time selected")
            } else {
                makeToast(toastString: Constants.AlertMessage.selectAvailableDay)
                return false
            }
        }
        if isTemporyAvail == true {
            if (availablitytModel?.tempJobDates.count)! > 0 {
                // debugPrint("Temp Jobs is there")
            } else {
                makeToast(toastString: Constants.AlertMessage.selectDate)
                return false
            }
        }
        
        return true
    }

    func minimumOneSelected() -> Bool {
        if isPartTimeDayShow == true {
            return true
        } else if isTemporyAvail == true {
            return true
        } else if isJobTypeFullTime == "1" {
            return true
        }
        return false
    }
}

extension DMCalendarSetAvailabillityVC: DMCalendarSetAvailabilityViewInput {
    
    func configureView(fromJobSelection: Bool) {
        
        self.fromJobSelection = fromJobSelection
        
        if fromJobSelection {
            UserDefaultsManager.sharedInstance.isProfileCompleted = true
            navigationItem.hidesBackButton = true
        } else {
            navigationItem.leftBarButtonItem = backBarButton()
        }
    }
    
    func reloadData() {
        calenderTableView.reloadData()
    }
    
    func configureWithAvailability(response: JSON) {
        
        if response[Constants.ServerKey.status].boolValue {
            let resultDic = response[Constants.ServerKey.result]
            self.availablitytModel = UserAvailability(dict: resultDic)
            if (self.availablitytModel?.isParttimeMonday)! || (self.availablitytModel?.isParttimeTuesday)! || (self.availablitytModel?.isParttimeWednesday)! || (self.availablitytModel?.isParttimeThursday)! || (self.availablitytModel?.isParttimeFriday)! || (self.availablitytModel?.isParttimeSaturday)! || (self.availablitytModel?.isParttimeSunday)! {
                self.availablitytModel?.isParttime = true
                self.isPartTimeDayShow = true
                self.isJobTypePartTime = "1"
                
            } else {
                self.availablitytModel?.isParttime = false
                self.isPartTimeDayShow = false
                self.isJobTypePartTime = "0"
            }
            if self.availablitytModel?.isFulltime == true {
                self.isJobTypeFullTime = "1"
                
            } else {
                self.isJobTypeFullTime = "0"
            }
            if (self.availablitytModel?.tempJobDates.count)! > 0 {
                self.isTemporyAvail = true
            } else {
                self.isTemporyAvail = false
            }
            
        } else {
            self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
        }
        
        calenderTableView.reloadData()
    }
}
