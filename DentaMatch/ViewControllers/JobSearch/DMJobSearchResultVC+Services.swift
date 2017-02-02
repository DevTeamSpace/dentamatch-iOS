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
    
    func fetchSearchResultAPI(params:[String:Any]) {
        debugPrint("Search Parameters\n\(params.description))")
        self.showLoader()
        APIManager.apiPost(serviceName: Constants.API.JobSearchResultAPI, parameters: params) { (response:JSON?, error:NSError?) in
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
            self.handleJobSearchResponse(response: response!)
        }
    }
    
    func handleJobSearchResponse(response:JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                let skillList = response[Constants.ServerKey.result][Constants.ServerKey.joblist].array
                for jobObject in (skillList)! {
                    let job = Job(job: jobObject)
                    self.jobs.append(job)
                }
                self.totalJobsFromServer = response[Constants.ServerKey.result]["total"].intValue
                self.jobsPageNo += 1
                self.loadingMoreJobs = false
                DispatchQueue.main.async {
                    self.tblJobSearchResult.reloadData()
                    self.tblJobSearchResult.tableFooterView = nil
                    self.lblResultCount.text = String(self.jobs.count) + Constants.Strings.whiteSpace + Constants.Strings.resultsFound
                }
            } else {
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
    
}
