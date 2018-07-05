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
    func getJobList(params: [String: String]) {
        // Loader management as we don't have to show loader in load more case
        if params["type"] == "1" {
            if savedJobsPageNo == 1 {
                showLoader()
            }
        } else if params["type"] == "2" {
            if appliedJobsPageNo == 1 {
                showLoader()
            }
        } else {
            if shortListedJobsPageNo == 1 {
                showLoader()
            }
        }
        APIManager.apiGet(serviceName: Constants.API.jobList, parameters: params) { (response: JSON?, error: NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            guard let _ = response else {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            // debugPrint(response!)
            self.handleJobListResponse(response: response, type: params["type"]!)
        }
    }

    func saveUnsaveJob(saveStatus: Int, jobId: Int, completionHandler: @escaping (JSON?, NSError?) -> Void) {
        let params = [
            Constants.ServerKey.jobId: jobId,
            Constants.ServerKey.status: saveStatus,
        ]
        showLoader()
        APIManager.apiPost(serviceName: Constants.API.saveJob, parameters: params) { (response: JSON?, error: NSError?) in
            self.hideLoader()
            completionHandler(response, error)
        }
    }

    func handleJobListResponse(response: JSON?, type: String) {
        if let response = response {
            // debugPrint("type returned = \(type)")

            if response[Constants.ServerKey.status].boolValue {
                if type == "1" {
                    // Saved Jobs
                    if savedJobsPageNo == 1 {
                        savedJobs.removeAll()
                    }
                    totalSavedJobsFromServer = response[Constants.ServerKey.result]["total"].intValue
                    let jobsArray = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                    for job in jobsArray {
                        let job = Job(job: job)
                        savedJobs.append(job)
                    }
                    pullToRefreshSavedJobs.endRefreshing()
                    savedJobsPageNo += 1
                    loadingMoreSavedJobs = false
                    placeHolderEmptyJobsView?.isHidden = savedJobs.count == 0 ? false : true
                    DispatchQueue.main.async {
                        self.savedJobsTableView.reloadData()
                        self.savedJobsTableView.tableFooterView = nil
                    }

                } else if type == "2" {
                    // Applied jons
                    if appliedJobsPageNo == 1 {
                        appliedJobs.removeAll()
                    }
                    totalAppliedJobsFromServer = response[Constants.ServerKey.result]["total"].intValue
                    let jobsArray = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                    for job in jobsArray {
                        let job = Job(job: job)
                        appliedJobs.append(job)
                    }
                    pullToRefreshAppliedJobs.endRefreshing()
                    appliedJobsPageNo += 1
                    loadingMoreAppliedJobs = false
                    placeHolderEmptyJobsView?.isHidden = appliedJobs.count == 0 ? false : true
                    DispatchQueue.main.async {
                        self.appliedJobsTableView.reloadData()
                        self.appliedJobsTableView.tableFooterView = nil
                    }
                } else if type == "3" {
                    // Shortlisted jobs
                    if shortListedJobsPageNo == 1 {
                        shortListedJobs.removeAll()
                    }
                    totalShortListedJobsFromServer = response[Constants.ServerKey.result]["total"].intValue

                    let jobsArray = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                    for job in jobsArray {
                        let job = Job(job: job)
                        shortListedJobs.append(job)
                    }
                    pullToRefreshShortListedJobs.endRefreshing()
                    shortListedJobsPageNo += 1
                    loadingMoreShortListedJobs = false
                    placeHolderEmptyJobsView?.isHidden = shortListedJobs.count == 0 ? false : true
                    DispatchQueue.main.async {
                        self.shortListedJobsTableView.reloadData()
                        self.shortListedJobsTableView.tableFooterView = nil
                    }
                }
            } else {
                if type == "1" {
                    if response[Constants.ServerKey.statusCode] == 201 {
                        pullToRefreshSavedJobs.endRefreshing()
                        loadingMoreSavedJobs = false
                        if savedJobsPageNo == 1 {
                            savedJobs.removeAll()
                        }
                        placeHolderEmptyJobsView?.isHidden = savedJobs.count == 0 ? false : true
                        DispatchQueue.main.async {
                            self.savedJobsTableView.reloadData()
                            self.savedJobsTableView.tableFooterView = UIView()
                        }
                    } else {
                        makeToast(toastString: response[Constants.ServerKey.message].stringValue)
                    }

                } else if type == "2" {
                    if response[Constants.ServerKey.statusCode] == 201 {
                        pullToRefreshAppliedJobs.endRefreshing()
                        loadingMoreAppliedJobs = false
                        if appliedJobsPageNo == 1 {
                            appliedJobs.removeAll()
                        }
                        placeHolderEmptyJobsView?.isHidden = appliedJobs.count == 0 ? false : true
                        DispatchQueue.main.async {
                            self.appliedJobsTableView.reloadData()
                            self.appliedJobsTableView.tableFooterView = UIView()
                        }
                    } else {
                        makeToast(toastString: response[Constants.ServerKey.message].stringValue)
                    }

                } else {
                    if response[Constants.ServerKey.statusCode] == 201 {
                        pullToRefreshShortListedJobs.endRefreshing()
                        loadingMoreShortListedJobs = false
                        if shortListedJobsPageNo == 1 {
                            shortListedJobs.removeAll()
                        }
                        placeHolderEmptyJobsView?.isHidden = shortListedJobs.count == 0 ? false : true
                        DispatchQueue.main.async {
                            self.shortListedJobsTableView.reloadData()
                            self.shortListedJobsTableView.tableFooterView = UIView()
                        }
                    } else {
                        makeToast(toastString: response[Constants.ServerKey.message].stringValue)
                    }
                }
            }
        } else {
            makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
        }
    }
}
