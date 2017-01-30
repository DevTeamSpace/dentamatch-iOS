//
//  DMJobTitleVC.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 11/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import SwiftyJSON

@objc protocol DMJobTitleVCDelegate {
    @objc optional func setSelectedJobType(jobTitles : [JobTitle])
}

class DMJobTitleVC: DMBaseVC {
    
    @IBOutlet weak var tblJobTitle: UITableView!
    var jobTitles = [JobTitle]()
    var selectedJobs = [JobTitle]()
    var rightBarBtn : UIButton = UIButton()
    var rightBarButtonItem : UIBarButtonItem = UIBarButtonItem()
    var cellHeight : CGFloat = 56.0
    var rightBarButtonWidth : CGFloat = 40.0
    weak var delegate : DMJobTitleVCDelegate?
    
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
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        self.title = Constants.ScreenTitleNames.jobTitle
        self.tblJobTitle.rowHeight = UITableViewAutomaticDimension
        self.tblJobTitle.register(UINib(nibName: "JobTitleCell", bundle: nil), forCellReuseIdentifier: "JobTitleCell")
        self.setRightBarButton(title: Constants.Strings.save, width : rightBarButtonWidth)
    }
    
//    func setRightBarButton()  {
//        self.rightBarBtn = UIButton()
//        self.rightBarBtn.setTitle("Save", for: .normal)
//        self.rightBarBtn.titleLabel?.font = UIFont.fontRegular(fontSize: 16.0)
//        self.rightBarBtn.frame = CGRect(x : 0,y : 0,width: 40,height : 25)
//        self.rightBarBtn.titleLabel?.textAlignment = .right
//        self.rightBarBtn.imageView?.contentMode = .scaleAspectFit
//        self.rightBarBtn.addTarget(self, action: #selector(DMJobTitleVC.actionRightNavigationItem), for: .touchUpInside)
//        self.rightBarButtonItem = UIBarButtonItem()
//        self.rightBarButtonItem.customView = self.rightBarBtn
//        self.navigationItem.rightBarButtonItem = rightBarButtonItem
//    }
    
    override func actionRightNavigationItem() {
        _ =  self.navigationController?.popViewController(animated: true)
        self.selectedJobs.removeAll()
        for objTitle in self.jobTitles {
            if objTitle.jobSelected == true {
                self.selectedJobs.append(objTitle)
            }
        }
        delegate?.setSelectedJobType!(jobTitles: self.selectedJobs)
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
            debugPrint(response!)
            self.handleJobListResponse(response: response!)
        }
    }
    
    func handleJobListResponse(response:JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                let skillList = response[Constants.ServerKey.result][Constants.ServerKey.joblists].array
                jobTitles.removeAll()
                for jobObject in (skillList)! {
                    let job = JobTitle(job: jobObject)
                    for selectedJob in selectedJobs {
                        if selectedJob.jobId == job.jobId {
                            job.jobSelected = true
                        }
                    }
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobTitleCell") as! JobTitleCell
        cell.selectionStyle = .none
        let objJob = jobTitles[indexPath.row]
        cell.lblJobTitle.textColor = UIColor.init(red: 81.0/255.0, green: 81.0/255.0, blue: 81.0/255.0, alpha: 1.0)
        cell.lblJobTitle.text = objJob.jobTitle
        if objJob.jobSelected == true {
            cell.btnTick.setTitle("w", for: .normal)
            cell.btnTick.setTitleColor(UIColor.init(red: 4.0/255.0, green: 112.0/255.0, blue: 192.0/255.0, alpha: 1.0), for: .normal)
        }
        else {
            cell.btnTick.setTitle("t", for: .normal)
            cell.btnTick.setTitleColor(UIColor.init(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? JobTitleCell
        let objJob = jobTitles[indexPath.row]
        if objJob.jobSelected == false {
            objJob.jobSelected = true
            cell?.btnTick.setTitle("w", for: .normal)
            cell?.btnTick.setTitleColor(UIColor.init(red: 4.0/255.0, green: 112.0/255.0, blue: 192.0/255.0, alpha: 1.0), for: .normal)
        }
        else {
            objJob.jobSelected = false
            cell?.btnTick.setTitle("t", for: .normal)
            cell?.btnTick.setTitleColor(UIColor.init(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0), for: .normal)
        }
    }
}
