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
    
    func handleJobListResponse(response:JSON?,type:String) {
        if let response = response {
            print("type returned = \(type)")
            
            if response[Constants.ServerKey.status].boolValue {
                if type == "1" {
                    //Saved Jobs
                    let jobsArray = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                    for job in jobsArray {
                        let job = Job(job: job)
                        self.savedJobs.append(job)
                        self.savedJobsTableView.reloadData()
                    }
                    savedJobsPageNo += 1
                } else if type == "2"{
                    //Applied jons
                    let jobsArray = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                    for job in jobsArray {
                        let job = Job(job: job)
                        self.appliedJobs.append(job)
                    }
                    appliedJobsPageNo += 1
                } else if type == "3" {
                    //Shortlisted jobs
                    let jobsArray = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                    for job in jobsArray {
                        let job = Job(job: job)
                        self.shortListedJobs.append(job)
                    }
                    shortListedJobsPageNo += 1
                }
            } else {
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)

            }
        } else {
            self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
        }
    }
}
