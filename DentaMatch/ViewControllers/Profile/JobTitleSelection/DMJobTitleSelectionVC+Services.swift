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
        showLoader()
        APIManager.apiGet(serviceName: Constants.API.getJobTitle, parameters: [:]) { (response: JSON?, error: NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            if response == nil {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            // debugPrint(response!)
            self.handleJobListResponse(response: response!)
        }
    }

    func handleJobListResponse(response: JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                let skillList = response[Constants.ServerKey.result][Constants.ServerKey.joblists].array
                for jobObject in skillList! {
                    let job = JobTitle(job: jobObject)
                    jobTitles.append(job)
                }
                jobSelectionPickerView.setup(jobTitles: jobTitles)
                jobSelectionPickerView.pickerView.reloadAllComponents()
                jobSelectionPickerView.backgroundColor = UIColor.white

            } else {
                makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }

    func uploadProfileImageAPI(textParams: [String: Any]) {
        var params = [String: AnyObject]()
        params["type"] = "profile_pic" as AnyObject?
        if let profileImageData = self.profileImage {
            if let imageData = profileImageData.jpegData(compressionQuality: 0.5) {
                params["image"] = imageData as AnyObject?
                showLoader()
                APIManager.apiMultipart(serviceName: Constants.API.uploadImage, parameters: params, completionHandler: { (response: JSON?, error: NSError?) in
                    self.hideLoader()
                    self.updateLicenseDetails(params: textParams)
                    if error != nil {
                        self.makeToast(toastString: (error?.localizedDescription)!)
                        return
                    }
                    if response == nil {
                        self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                        return
                    }

                    // debugPrint(response!)
                    self.handleUploadProfileResponse(response: response)

                })
            } else {
                makeToast(toastString: "Profile Image problem")
                updateLicenseDetails(params: params)
            }
        }
    }

    func handleUploadProfileResponse(response: JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                UserManager.shared().activeUser.profileImageURL = response[Constants.ServerKey.result][Constants.ServerKey.profileImageURL].stringValue
                makeToast(toastString: response[Constants.ServerKey.message].stringValue)
                // openLicenseScreen()
            } else {
                makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }

    func updateLicenseDetails(params: [String: Any]) {
        showLoader()

        APIManager.apiPut(serviceName: Constants.API.licenseNumberAndState, parameters: params) { (response: JSON?, error: NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            if response == nil {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            // debugPrint(response!)
            self.handleUpdateLicenseResponse(response: response)
        }
    }

    func handleUpdateLicenseResponse(response: JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                // move to congrats screen
                let profileSuccessPendingVC = UIStoryboard.profileStoryBoard().instantiateViewController(type: DMProfileSuccessPending.self)!
                let user = response[Constants.ServerKey.result]["userDetails"]
                if user["isVerified"].stringValue == "1" {
                    profileSuccessPendingVC.isEmailVerified = true
                }
                if selectedJobTitle!.isLicenseRequired {
                    profileSuccessPendingVC.isLicenseRequired = true
                }
                UserManager.shared().activeUser.jobTitle = user[Constants.ServerKey.jobtitleName].stringValue
                UserManager.shared().activeUser.jobTitleId = user[Constants.ServerKey.jobTitileId].stringValue
                UserManager.shared().activeUser.profileImageURL = user[Constants.ServerKey.profilePic].stringValue
                UserManager.shared().activeUser.preferredJobLocation = user[Constants.ServerKey.preferredLocationName].stringValue
                UserManager.shared().activeUser.preferredLocationId = user[Constants.ServerKey.preferredJobLocationId].stringValue
                UserManager.shared().activeUser.state = user[Constants.ServerKey.state].stringValue
                UserManager.shared().activeUser.licenseNumber = user[Constants.ServerKey.licenseNumber].stringValue
                UserManager.shared().activeUser.isJobSeekerVerified = user["isJobSeekerVerified"].boolValue
                let myuser : User = UserManager.shared().activeUser
                print("user job\(myuser.isJobSeekerVerified ?? false)")
                UserManager.shared().saveActiveUser()

                navigationController?.pushViewController(profileSuccessPendingVC, animated: true)
            } else {
                makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
}
