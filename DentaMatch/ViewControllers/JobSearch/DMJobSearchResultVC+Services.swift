//
//  DMJobSearchResultVC+Services.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 31/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMJobSearchResultVC {
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

    func fetchSearchResultAPI(params: [String: Any]) {
        // debugPrint("Search Parameters\n\(params.description))")

        if jobsPageNo == 1 {
            showLoader()
        }
        APIManager.apiPostWithJSONEncode(serviceName: Constants.API.JobSearchResultAPI, parameters: params) { (response: JSON?, error: NSError?) in
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
            self.handleJobSearchResponse(response: response!)
        }
    }

    func handleJobSearchResponse(response: JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                let result = response[Constants.ServerKey.result]
                if result["isJobSeekerVerified"].stringValue == "0" {
                    showBanner(status: 1)
                } else if result["profileCompleted"].stringValue == "0" {
                    showBanner(status: 2)
                }

                if result["isJobSeekerVerified"].stringValue == "1" && result["profileCompleted"].stringValue == "1" {
                    hideBanner()
                }

                let skillList = response[Constants.ServerKey.result][Constants.ServerKey.joblist].array
                if jobsPageNo == 1 {
                    jobs.removeAll()
                }
                for jobObject in skillList! {
                    let job = Job(job: jobObject)
                    jobs.append(job)
                }
                placeHolderEmptyJobsView?.isHidden = jobs.count > 0 ? true : false

                totalJobsFromServer = response[Constants.ServerKey.result]["total"].intValue
                jobsPageNo += 1
                loadingMoreJobs = false
                DispatchQueue.main.async {
                    if self.isMapShow == true {
                        self.restoreAllMarkers()
                    } else {
                        self.tblJobSearchResult.tableFooterView = nil
                        self.lblResultCount.text = String(self.totalJobsFromServer) + Constants.Strings.whiteSpace + Constants.Strings.resultsFound
                    }
                    self.tblJobSearchResult.reloadData()
                }
            } else {
                jobs.removeAll()
                DispatchQueue.main.async {
                    self.lblResultCount.text = Constants.Strings.zero + Constants.Strings.whiteSpace + Constants.Strings.resultsFound
                    self.tblJobSearchResult.reloadData()
                }
                makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }

    func getUnreadNotificationCount(completionHandler: @escaping (JSON?, NSError?) -> Void) {
//        self.showLoader()
        APIManager.apiGet(serviceName: Constants.API.unreadNotificationCount, parameters: nil) { (response: JSON?, error: NSError?) in
//            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            if response == nil {
//                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            completionHandler(response, error)
//            self.handleAboutMeResponse(response: response)
        }
    }
}
