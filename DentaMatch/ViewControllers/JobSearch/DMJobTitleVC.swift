//
//  DMJobTitleVC.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 11/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import SwiftyJSON

class DMJobTitleVC: DMBaseVC {
    
    @IBOutlet weak var tblJobTitle: UITableView!
    var jobTitles = [JobTitle]()
    var rightBarBtn : UIButton = UIButton()
    var rightBarButtonItem : UIBarButtonItem = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getJobsAPI()
        self.setUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK : Private Method
    
    func setUp() {
        self.setRightBarButton()
        self.title = "JOB TITLE"
        self.tblJobTitle.rowHeight = UITableViewAutomaticDimension
            self.tblJobTitle.register(UINib(nibName: "AffiliationsCell", bundle: nil), forCellReuseIdentifier: "AffiliationsCell")
    }
    
    func setRightBarButton()  {
        self.rightBarBtn = UIButton()
        self.rightBarBtn.setTitle("Save", for: .normal)
        self.rightBarBtn.frame = CGRect(x : 0,y : 0,width: 50,height : 25)
        self.rightBarBtn.imageView?.contentMode = .scaleAspectFit
        self.rightBarBtn.addTarget(self, action: #selector(DMJobTitleVC.actionRightNavigationItem), for: .touchUpInside)
        self.rightBarButtonItem = UIBarButtonItem()
        self.rightBarButtonItem.customView = self.rightBarBtn
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func actionRightNavigationItem() {
        
    }
    
    func getJobsAPI() {
        self.showLoader()
        APIManager.apiGet(serviceName: Constants.API.getJobTitleAPI, parameters: [:]) { (response:JSON?, error:NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            if response == nil {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            print(response!)
            self.handleJobListResponse(response: response!)
        }
    }
    
    func handleJobListResponse(response:JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                let skillList = response[Constants.ServerKey.result][Constants.ServerKey.joblists].array
                for jobObject in skillList! {
                    let job = JobTitle(job: jobObject)
                    jobTitles.append(job)
                }
                self.tblJobTitle.reloadData()
            } else {
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
}

extension DMJobTitleVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AffiliationsCell") as! AffiliationsCell
        cell.selectionStyle = .none
        let objJob = jobTitles[indexPath.row]
        cell.tickButton.isEnabled = false
        cell.affiliationLabel.textColor = UIColor.init(red: 81.0/255.0, green: 81.0/255.0, blue: 81.0/255.0, alpha: 1.0)
        cell.affiliationLabel.text = objJob.jobTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? AffiliationsCell
        let objJob = jobTitles[indexPath.row]
        if objJob.jobSelected == false {
            objJob.jobSelected = true
            cell?.tickButton.setTitle("w", for: .normal)
            cell?.tickButton.setTitleColor(UIColor.init(red: 4.0/255.0, green: 112.0/255.0, blue: 192.0/255.0, alpha: 1.0), for: .normal)
        }
        else {
            objJob.jobSelected = false
            cell?.tickButton.setTitle("t", for: .normal)
            cell?.tickButton.setTitleColor(UIColor.init(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0), for: .normal)
        }
        
    }
}
