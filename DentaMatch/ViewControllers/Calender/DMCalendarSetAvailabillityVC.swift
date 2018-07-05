//
//  DMCalendarSetAvailabillityVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 26/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMCalendarSetAvailabillityVC: DMBaseVC {
    @IBOutlet var calenderTableView: UITableView!
    var isPartTimeDayShow: Bool = false
    var isTemporyAvail: Bool = false
    var fromJobSelection = false

//    var partTimeJobDays = [String]()
//    var tempJobDays = [String]()

    var isJobTypeFullTime: String! = "0"
    var isJobTypePartTime: String! = "0"
    var availablitytModel: UserAvailability? = UserAvailability()
    var gregorian: NSCalendar?
    var fromRoot = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        calenderTableView.rowHeight = UITableViewAutomaticDimension
        calenderTableView.separatorStyle = .none
        calenderTableView.register(UINib(nibName: "JobSearchTypeCell", bundle: nil), forCellReuseIdentifier: "JobSearchTypeCell")
        calenderTableView.register(UINib(nibName: "JobSearchPartTimeCell", bundle: nil), forCellReuseIdentifier: "JobSearchPartTimeCell")
        calenderTableView.register(UINib(nibName: "TemporyJobCalenderCell", bundle: nil), forCellReuseIdentifier: "TemporyJobCalenderCell")
        calenderTableView.register(UINib(nibName: "TemporyJobCell", bundle: nil), forCellReuseIdentifier: "TemporyJobCell")

        navigationItem.rightBarButtonItem = rightBarButton()
        if fromJobSelection {
            UserDefaultsManager.sharedInstance.isProfileCompleted = true
            // self.autoFillData()
            navigationItem.hidesBackButton = true
        } else {
            navigationItem.leftBarButtonItem = backBarButton()
        }
        let month1 = Date.getMonthAndYearForm(date: Date())
        getMyAvailabilityFromServer(month: month1.month, year: month1.year) { _, _ in

            self.calenderTableView.reloadData()
        }
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
//        if !minimumOneSelected() {
//            self.makeToast(toastString: Constants.AlertMessage.selectOneAvailableOption)
//           return
//        }
        if !checkValidations() {
            return
        }

        setMyAvailabilityOnServer { _, _ in
            // debugPrint(response ?? "response not available")
            if self.fromJobSelection {
                kAppDelegate.goToDashBoard()
            } else {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
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
