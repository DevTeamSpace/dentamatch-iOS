//
//  DMPublicProfileVC+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 25/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMPublicProfileVC {
    
    func uploadProfileImageAPI() {
        var params = [String:AnyObject]()
        params["type"] = "profile_pic" as AnyObject?
        if let profileImageData = self.profileImage {
            if let imageData = UIImageJPEGRepresentation(profileImageData, 0.5) {
                params["image"] = imageData as AnyObject?
                self.showLoader()
                APIManager.apiMultipart(serviceName: Constants.API.uploadImage, parameters: params, completionHandler: { (response:JSON?, error:NSError?) in
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
                    self.handleUploadProfileResponse(response: response)
                })
            } else {
                self.makeToast(toastString: "Profile Image problem")
            }
        }
    }
    
    func updatePublicProfileAPI(params:[String:String]) {
        
        self.showLoader()
        APIManager.apiPut(serviceName: Constants.API.updateUserProfile, parameters: params) { (response:JSON?, error:NSError?) in
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
            self.handleUpdateProfileResponse(response: response)
        }
    }
    
    func handleUploadProfileResponse(response:JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                UserManager.shared().activeUser.profileImageURL = response[Constants.ServerKey.result][Constants.ServerKey.profileImageURL].stringValue
                UserManager.shared().saveActiveUser()
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
                self.updateProfileScreen()
                DispatchQueue.main.async {
                    self.publicProfileTableView.reloadData()
                }
            } else {
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
    
    func handleUpdateProfileResponse(response:JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                updateUserDetailsOnSuccess()
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
                self.updateProfileScreen()
                _ = self.navigationController?.popViewController(animated: true)
            } else {
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
    
    func updateUserDetailsOnSuccess() {
        UserManager.shared().activeUser.firstName = editProfileParams[Constants.ServerKey.firstName]
        UserManager.shared().activeUser.lastName = editProfileParams[Constants.ServerKey.lastName]
        UserManager.shared().activeUser.preferredJobLocation = editProfileParams[Constants.ServerKey.preferredJobLocation]
        UserManager.shared().activeUser.jobTitleId = editProfileParams["jobTitileId"]
        UserManager.shared().activeUser.latitude = editProfileParams[Constants.ServerKey.latitude]
        UserManager.shared().activeUser.longitude = editProfileParams[Constants.ServerKey.longitude]
        UserManager.shared().activeUser.aboutMe = editProfileParams[Constants.ServerKey.aboutMe]
        UserManager.shared().activeUser.zipCode = editProfileParams["zipcode"]
        UserManager.shared().activeUser.jobTitle = (jobTitles.filter({$0.jobId == Int(self.selectedJobTitleId)}).first)?.jobTitle
        UserManager.shared().saveActiveUser()
    }
}
