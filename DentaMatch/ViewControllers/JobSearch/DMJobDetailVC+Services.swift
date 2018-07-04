//
//  DMJobDetailVC+Services.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 01/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMJobDetailVC {
    
    func saveUnsaveJob(saveStatus:Int,jobId:Int,completionHandler: @escaping (JSON?, NSError?) -> ()) {
        let params = [
            Constants.ServerKey.jobId:jobId,
            Constants.ServerKey.status:saveStatus
        ]
        self.showLoader()
        APIManager.apiPost(serviceName: Constants.API.saveJob, parameters: params) { (response:JSON?, error:NSError?) in
            self.hideLoader()
            completionHandler(response,error)
        }
    }
    
    func fetchJobAPI(params:[String:Any]) {
        //debugPrint("Job Detail Parameters\n\(params.description))")
        self.showLoader()
        APIManager.apiPost(serviceName: Constants.API.jobDetail, parameters: params) { (response:JSON?, error:NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            guard let _ = response else {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            //debugPrint(response!)
            self.handleJobDetailResponse(response: response!)
        }
    }
    
    func handleJobDetailResponse(response:JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                let job = Job(job: response[Constants.ServerKey.result])
                self.job = job as Job
                
                /* For Job status
                 INVITED = 1
                 APPLIED = 2
                 SHORTLISTED = 3
                 HIRED = 4
                 REJECTED = 5
                 CANCELLED = 6
                 */
                
                if job.isApplied == 1 || job.isApplied == 2 || job.isApplied == 3 || job.isApplied == 4 || job.isApplied == 5 {
                    //Hide apply for job button
                    self.btnApplyForJob.isUserInteractionEnabled = false
                    self.btnApplyForJob.isHidden = true
                    self.constraintBtnApplyJobHeight.constant = 0
                    self.btnApplyForJob.setTitle(Constants.Strings.appliedForThisJob, for: .normal)
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                    }
                }
                else {
                    //If its temp job and cancelled
                    if job.jobType == 3 {
                        self.btnApplyForJob.isUserInteractionEnabled = false
                        self.btnApplyForJob.isHidden = true
                        self.constraintBtnApplyJobHeight.constant = 0
                        DispatchQueue.main.async {
                            self.view.layoutIfNeeded()
                        }
                    } else {
                        self.btnApplyForJob.isUserInteractionEnabled = true
                        self.btnApplyForJob.isHidden = false
                        self.constraintBtnApplyJobHeight.constant = 49
                        self.btnApplyForJob.setTitle(Constants.Strings.applyForJob, for: .normal)
                        DispatchQueue.main.async {
                            self.view.layoutIfNeeded()
                        }
                    }
                }
                self.tblJobDetail.isHidden = false
                self.tblJobDetail.reloadData()
            } else {
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
    
    func applyJobAPI(params:[String:Any]) {
        //debugPrint("Search Parameters\n\(params.description))")
        self.showLoader()
        APIManager.apiPost(serviceName: Constants.API.applyJob, parameters: params) { (response:JSON?, error:NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            guard let _ = response else {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            //debugPrint(response!)
            self.handleApplyJobResponse(response: response!)
        }
    }
    
    func handleApplyJobResponse(response:JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                
                self.alertMessage(title: Constants.AlertMessage.congratulations, message: Constants.AlertMessage.jobApplied, buttonText: kOkButtonTitle, completionHandler: {
                })
                job?.isApplied = 2
                if let delegate = self.delegate {
                    if fromTrack {
                        delegate.jobApplied!(job: job!)
                    }
                }
                DispatchQueue.main.async {
                    self.btnApplyForJob.isHidden = true
                    self.constraintBtnApplyJobHeight.constant = 0
                    self.btnApplyForJob.setTitle(Constants.Strings.appliedForThisJob, for: .normal)
                    self.tblJobDetail.reloadData()
                }
                
            } else {
                if response[Constants.ServerKey.statusCode].intValue == 200 {
                    self.alertMessage(title: "", message: response[Constants.ServerKey.message].stringValue, buttonText: "Ok", completionHandler: { 
                        
                    })
                } else {
                    DispatchQueue.main.async {
                        kAppDelegate.showOverlay(isJobSeekerVerified: true)
                    }
//                    self.alertMessage(title: Constants.AlertMessage.completeYourProfile, message: Constants.AlertMessage.completeYourProfileDetailMsg, leftButtonText: Constants.Strings.no, rightButtonText: Constants.Strings.yes, completionHandler: { (isLeftButtonPressed) in
//                        if isLeftButtonPressed {
//                            //debugPrint("Left Button Pressed")
//                        }
//                        else {
//                            self.tabBarController?.selectedIndex = 4
//                        }
//
//                    })
                }
            }
        }
    }
}
