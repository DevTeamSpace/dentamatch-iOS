//
//  DMJobTitleSelectionVC+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 09/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMJobTitleSelectionVC {
    
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
            print(response!)
            self.handleJobListResponse(response: response!)
        }
    }
    
    func handleJobListResponse(response:JSON?) {
        let pickerView = JobSelectionPickerView.loadJobSelectionView(withJobTitles: [])
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                let skillList = response[Constants.ServerKey.result][Constants.ServerKey.skillList].array
                for jobObject in skillList! {
                    let job = JobTitle(job: jobObject)
                    jobTitles.append(job)
                }
                pickerView.setup(jobTitles: jobTitles)
                jobSelectionPickerTextField.inputView = pickerView
                pickerView.delegate = self
                pickerView.pickerView.reloadAllComponents()
                pickerView.backgroundColor = UIColor.white
                
            } else {
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
    
    func uploadProfileImageAPI() {
        var params = [String:AnyObject]()
        params["type"] = "profile_pic" as AnyObject?
        if let profileImageData = self.profileImage {
            if let imageData = UIImageJPEGRepresentation(profileImageData, 0.5) {
                params["image"] = imageData as AnyObject?
                APIManager.apiMultipart(serviceName: Constants.API.uploadImageAPI, parameters: params, completionHandler: { (response:JSON?, error:NSError?) in
                    
                    print(response!)
                })
            } else {
                self.makeToast(toastString: "Profile Image problem")
            }
        }
    }
}
