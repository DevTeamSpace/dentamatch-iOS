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
        debugPrint("Job Detail Parameters\n\(params.description))")
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
            debugPrint(response!)
            self.handleJobDetailResponse(response: response!)
        }
    }
    
    func handleJobDetailResponse(response:JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                let job = Job(job: response[Constants.ServerKey.result])
                self.job = job as Job
                if job.isApplied == 1 {
                    self.btnApplyForJob.isUserInteractionEnabled = false
                    self.btnApplyForJob.setTitle(Constants.Strings.appliedForThisJob, for: .normal)
                }
                else {
                    self.btnApplyForJob.isUserInteractionEnabled = true
                    self.btnApplyForJob.setTitle(Constants.Strings.applyForJob, for: .normal)
                }
                self.tblJobDetail.isHidden = false
                self.btnApplyForJob.isHidden = false
                self.tblJobDetail.reloadData()
            } else {
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
    
    func applyJobAPI(params:[String:Any]) {
        debugPrint("Search Parameters\n\(params.description))")
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
            debugPrint(response!)
            self.handleApplyJobResponse(response: response!)
        }
    }
    
    func handleApplyJobResponse(response:JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                self.alertMessage(title: Constants.AlertMessage.congratulations, message: Constants.AlertMessage.jobApplied, buttonText: kOkButtonTitle, completionHandler: {
                })
                _ = self.navigationController?.popViewController(animated: true)
                
            } else {
                
                self.alertMessage(title: Constants.AlertMessage.completeYourProfile, message: Constants.AlertMessage.completeYourProfileDetailMsg, leftButtonText: Constants.Strings.no, rightButtonText: Constants.Strings.yes, completionHandler: { (isLeftButtonPressed) in
                    if isLeftButtonPressed {
                        
                    }
                    else {
                       self.tabBarController?.selectedIndex = 4
                    }
                    
                })
            }
        }
    }
}
