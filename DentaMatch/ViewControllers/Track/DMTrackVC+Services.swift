//
//  DMTrackVC+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 27/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMTrackVC {
    
    func getJobList(params:[String:String]) {
        
        self.showLoader()
        APIManager.apiGet(serviceName: Constants.API.jobList, parameters: params) { (response:JSON?, error:NSError?) in
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
            self.handleJobListResponse(response: response,type: params["type"]!)
        }
    }
    
    func saveUnsaveJob(saveStatus:Int,jobId:Int,completionHandler: @escaping (JSON?, NSError?) -> ()) {
        let params = [
            Constants.ServerKey.jobId:jobId,
            Constants.ServerKey.status:saveStatus
            ]
        
        APIManager.apiPost(serviceName: Constants.API.saveJob, parameters: params) { (response:JSON?, error:NSError?) in
            
            completionHandler(response,error)
        }
    }
    
    func handleJobListResponse(response:JSON?,type:String) {
        if let response = response {
            print("type returned = \(type)")
            
            if response[Constants.ServerKey.status].boolValue {
                
                if type == "1" {
                    //Saved Jobs
                    self.totalSavedJobsFromServer = response[Constants.ServerKey.result]["total"].intValue
                    let jobsArray = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                    for job in jobsArray {
                        let job = Job(job: job)
                        self.savedJobs.append(job)
                    }
                    savedJobsPageNo += 1
                    self.loadingMoreSaveJobs = false
                    DispatchQueue.main.async {
                        self.savedJobsTableView.reloadData()
                        self.savedJobsTableView.tableFooterView = UIView()
                    }
                    
                } else if type == "2"{
                    //Applied jons
                    self.totalAppliedJobsFromServer = response[Constants.ServerKey.result]["total"].intValue
                    
                    let jobsArray = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                    for job in jobsArray {
                        let job = Job(job: job)
                        self.appliedJobs.append(job)
                    }
                    appliedJobsPageNo += 1
                    
                } else if type == "3" {
                    //Shortlisted jobs
                    self.totalShortListedJobsFromServer = response[Constants.ServerKey.result]["total"].intValue
                    
                    let jobsArray = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                    for job in jobsArray {
                        let job = Job(job: job)
                        self.shortListedJobs.append(job)
                    }
                    shortListedJobsPageNo += 1
                }
            } else {
                
                if type == "1" {
                    if response[Constants.ServerKey.statusCode] == 201 {
                        DispatchQueue.main.async {
                            self.savedJobsTableView.reloadData()
                            self.savedJobsTableView.tableFooterView = UIView()
                        }
                    }
                    
                } else if type == "2" {
                    if response[Constants.ServerKey.statusCode] == 201 {
                        DispatchQueue.main.async {
                            self.appliedJobsTableView.reloadData()
                            self.appliedJobsTableView.tableFooterView = UIView()
                        }
                    }
                    
                } else {
                    if response[Constants.ServerKey.statusCode] == 201 {
                        DispatchQueue.main.async {
                            self.shortListedJobsTableView.reloadData()
                            self.shortListedJobsTableView.tableFooterView = UIView()
                        }
                    }
                }
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        } else {
            self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
        }
    }
}
