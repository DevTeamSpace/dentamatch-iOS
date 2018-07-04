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
        
        //Loader management as we don't have to show loader in load more case
        if params["type"] == "1" {
            if self.savedJobsPageNo == 1 {
                self.showLoader()
            }
        } else if params["type"] == "2" {
            if self.appliedJobsPageNo == 1 {
                self.showLoader()
            }
        } else {
            if self.shortListedJobsPageNo == 1 {
                self.showLoader()
            }
        }
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
            //debugPrint(response!)
            self.handleJobListResponse(response: response,type: params["type"]!)
        }
    }
    
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
    
    func handleJobListResponse(response:JSON?,type:String) {
        if let response = response {
            //debugPrint("type returned = \(type)")
            
            if response[Constants.ServerKey.status].boolValue {
                if type == "1" {
                    //Saved Jobs
                    if self.savedJobsPageNo == 1 {
                        self.savedJobs.removeAll()
                    }
                    self.totalSavedJobsFromServer = response[Constants.ServerKey.result]["total"].intValue
                    let jobsArray = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                    for job in jobsArray {
                        let job = Job(job: job)
                        self.savedJobs.append(job)
                    }
                    self.pullToRefreshSavedJobs.endRefreshing()
                    savedJobsPageNo += 1
                    self.loadingMoreSavedJobs = false
                    self.placeHolderEmptyJobsView?.isHidden = self.savedJobs.count == 0 ? false : true
                    DispatchQueue.main.async {
                        self.savedJobsTableView.reloadData()
                        self.savedJobsTableView.tableFooterView = nil
                        
                    }
                    
                } else if type == "2" {
                    //Applied jons
                    if self.appliedJobsPageNo == 1 {
                        self.appliedJobs.removeAll()
                    }
                    self.totalAppliedJobsFromServer = response[Constants.ServerKey.result]["total"].intValue
                    let jobsArray = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                    for job in jobsArray {
                        let job = Job(job: job)
                        self.appliedJobs.append(job)
                    }
                    self.pullToRefreshAppliedJobs.endRefreshing()
                    appliedJobsPageNo += 1
                    self.loadingMoreAppliedJobs = false
                    self.placeHolderEmptyJobsView?.isHidden = self.appliedJobs.count == 0 ? false : true
                    DispatchQueue.main.async {
                        self.appliedJobsTableView.reloadData()
                        self.appliedJobsTableView.tableFooterView = nil
                    }
                } else if type == "3" {
                    //Shortlisted jobs
                    if self.shortListedJobsPageNo == 1 {
                        self.shortListedJobs.removeAll()
                    }
                    self.totalShortListedJobsFromServer = response[Constants.ServerKey.result]["total"].intValue
                    
                    let jobsArray = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                    for job in jobsArray {
                        let job = Job(job: job)
                        self.shortListedJobs.append(job)
                    }
                    self.pullToRefreshShortListedJobs.endRefreshing()
                    shortListedJobsPageNo += 1
                    self.loadingMoreShortListedJobs = false
                    self.placeHolderEmptyJobsView?.isHidden = self.shortListedJobs.count == 0 ? false : true
                    DispatchQueue.main.async {
                        self.shortListedJobsTableView.reloadData()
                        self.shortListedJobsTableView.tableFooterView = nil
                    }
                }
            } else {
                if type == "1" {
                    if response[Constants.ServerKey.statusCode] == 201 {
                        self.pullToRefreshSavedJobs.endRefreshing()
                        self.loadingMoreSavedJobs = false
                        if self.savedJobsPageNo == 1 {
                            self.savedJobs.removeAll()
                        }
                        self.placeHolderEmptyJobsView?.isHidden = self.savedJobs.count == 0 ? false : true
                        DispatchQueue.main.async {
                            self.savedJobsTableView.reloadData()
                            self.savedJobsTableView.tableFooterView = UIView()
                        }
                    } else {
                        self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
                    }
                    
                } else if type == "2" {
                    if response[Constants.ServerKey.statusCode] == 201 {
                        self.pullToRefreshAppliedJobs.endRefreshing()
                        self.loadingMoreAppliedJobs = false
                        if self.appliedJobsPageNo == 1 {
                            self.appliedJobs.removeAll()
                        }
                        self.placeHolderEmptyJobsView?.isHidden = self.appliedJobs.count == 0 ? false : true
                        DispatchQueue.main.async {
                            self.appliedJobsTableView.reloadData()
                            self.appliedJobsTableView.tableFooterView = UIView()
                        }
                    } else {
                        self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
                    }
                    
                } else {
                    if response[Constants.ServerKey.statusCode] == 201 {
                        self.pullToRefreshShortListedJobs.endRefreshing()
                        self.loadingMoreShortListedJobs = false
                        if self.shortListedJobsPageNo == 1 {
                            self.shortListedJobs.removeAll()
                        }
                        self.placeHolderEmptyJobsView?.isHidden = self.shortListedJobs.count == 0 ? false : true
                        DispatchQueue.main.async {
                            self.shortListedJobsTableView.reloadData()
                            self.shortListedJobsTableView.tableFooterView = UIView()
                        }
                    } else {
                        self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
                    }

                }
            }
        } else {
            self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
        }
    }
}
