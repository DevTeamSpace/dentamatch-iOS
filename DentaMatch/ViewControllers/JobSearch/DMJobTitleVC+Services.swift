//
//  DMJobTitleVC+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 13/12/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMJobTitleVC {
    
    func getPreferredJobs() {
        self.showLoader()
        APIManager.apiGet(serviceName: Constants.API.getPreferredJobLocations, parameters: nil) { (response:JSON?, error:NSError?) in
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
            if response![Constants.ServerKey.status].boolValue {
                let preferredJobLocationArray = response!["result"]["preferredJobLocations"].arrayValue
                self.preferredLocations.removeAll()
                for location in preferredJobLocationArray {
                    
                    let preferredLocation = PreferredLocation(preferredLocation: location)
                    for selectedLocation in self.selectedPreferredLocations {
                        if preferredLocation.id == selectedLocation.id {
                            preferredLocation.isSelected = true
                        }
                    }
                    self.preferredLocations.append(preferredLocation)
                   
                }
                self.tblJobTitle.reloadData()

            } else {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
            }
        }
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
