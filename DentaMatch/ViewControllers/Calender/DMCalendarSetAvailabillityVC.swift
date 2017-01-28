//
//  DMCalendarSetAvailabillityVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 26/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMCalendarSetAvailabillityVC: DMBaseVC {
    @IBOutlet weak var calenderTableView: UITableView!
    var isPartTimeDayShow : Bool = false
    var isTemporyAvail : Bool = false

    var partTimeJobDays = [String]()
    var tempJobDays = [String]()

    var isJobTypeFullTime : String! = "0"
    var isJobTypePartTime : String! = "0"


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        self.title = "SET AVAILABILITY"
        self.calenderTableView.rowHeight = UITableViewAutomaticDimension
        self.calenderTableView.separatorStyle = .none
        self.calenderTableView.register(UINib(nibName: "JobSearchTypeCell", bundle: nil), forCellReuseIdentifier: "JobSearchTypeCell")
        self.calenderTableView.register(UINib(nibName: "JobSearchPartTimeCell", bundle: nil), forCellReuseIdentifier: "JobSearchPartTimeCell")
        self.calenderTableView.register(UINib(nibName: "TemporyJobCalenderCell", bundle: nil), forCellReuseIdentifier: "TemporyJobCalenderCell")
        self.calenderTableView.register(UINib(nibName: "TemporyJobCell", bundle: nil), forCellReuseIdentifier: "TemporyJobCell")
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        self.navigationItem.rightBarButtonItem = self.rightBarButton()

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
    func saveButtonPressed() {
        if !minimumOneSelected() {
            self.makeToast(toastString: Constants.AlertMessage.selectOneAvailableOption)
           return
        }
        if !checkValidations() {
            return
        }
        
        setMyAvailabilityOnServer { (response, error) in
            print(response ?? "response not available")
            _ = self.navigationController?.popViewController(animated: true)

        }
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func checkValidations() -> Bool {
        if isPartTimeDayShow == true {
            
            if partTimeJobDays.count > 0
            {
                return true

            }else{
                self.makeToast(toastString: Constants.AlertMessage.selectAvailableDay)
                return false
            }
        }
        if isTemporyAvail == true {
            if tempJobDays.count > 0
            {
                return true
            }else{
                self.makeToast(toastString: Constants.AlertMessage.selectDate)
                return false
            }

        }
    return true
    }
    func minimumOneSelected() -> Bool {
        if isPartTimeDayShow == true
        {
            return true
        }else if isTemporyAvail == true {
            return true
        }else if isJobTypeFullTime == "1" {
            return true
        }
        return false
    }

}
