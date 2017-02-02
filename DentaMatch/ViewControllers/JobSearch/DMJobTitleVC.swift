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
    
    //MARK : Private Method
    func setUp() {
        self.title = Constants.ScreenTitleNames.jobTitle
        self.tblJobTitle.rowHeight = UITableViewAutomaticDimension
        self.tblJobTitle.register(UINib(nibName: "JobTitleCell", bundle: nil), forCellReuseIdentifier: "JobTitleCell")
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        self.setRightBarButton(title: Constants.Strings.save, imageName : "" ,width : rightBarButtonWidth, font : UIFont.fontRegular(fontSize: 16.0)!)
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
            cell.btnTick.setTitle(Constants.DesignFont.acceptTermsSelected, for: .normal)
            cell.btnTick.setTitleColor(Constants.Color.tickSelectColor, for: .normal)
        }
        else {
            cell.btnTick.setTitle(Constants.DesignFont.acceptTermsDeSelected, for: .normal)
            cell.btnTick.setTitleColor(Constants.Color.tickDeselectColor, for: .normal)
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
            cell?.btnTick.setTitle(Constants.DesignFont.acceptTermsSelected, for: .normal)
            cell?.btnTick.setTitleColor(Constants.Color.tickSelectColor, for: .normal)
        }
        else {
            objJob.jobSelected = false
            cell?.btnTick.setTitle(Constants.DesignFont.acceptTermsDeSelected, for: .normal)
            cell?.btnTick.setTitleColor(Constants.Color.tickDeselectColor, for: .normal)
        }
    }
}
