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
        self.calenderTableView.rowHeight = UITableViewAutomaticDimension
        self.calenderTableView.separatorStyle = .none
        self.calenderTableView.register(UINib(nibName: "JobSearchTypeCell", bundle: nil), forCellReuseIdentifier: "JobSearchTypeCell")
        self.calenderTableView.register(UINib(nibName: "JobSearchPartTimeCell", bundle: nil), forCellReuseIdentifier: "JobSearchPartTimeCell")
        self.calenderTableView.register(UINib(nibName: "TemporyJobCalenderCell", bundle: nil), forCellReuseIdentifier: "TemporyJobCalenderCell")
        self.calenderTableView.register(UINib(nibName: "TemporyJobCell", bundle: nil), forCellReuseIdentifier: "TemporyJobCell")
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
