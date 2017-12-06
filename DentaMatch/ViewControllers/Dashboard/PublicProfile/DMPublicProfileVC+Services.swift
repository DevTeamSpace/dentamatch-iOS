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
        UserManager.shared().activeUser.preferredLocationId = editProfileParams[Constants.ServerKey.preferredJobLocationId]

        UserManager.shared().activeUser.jobTitleId = "\(selectedJob.jobId)"
        UserManager.shared().activeUser.jobTitle = selectedJob.jobTitle

        UserManager.shared().activeUser.aboutMe = editProfileParams[Constants.ServerKey.aboutMe]
        if let _ = editProfileParams[Constants.ServerKey.state] {
            UserManager.shared().activeUser.state = editProfileParams[Constants.ServerKey.state]
        } else {
            UserManager.shared().activeUser.state = ""
        }
        if let _ = editProfileParams[Constants.ServerKey.licenseNumber] {
            UserManager.shared().activeUser.licenseNumber = editProfileParams[Constants.ServerKey.licenseNumber]
        } else {
            UserManager.shared().activeUser.licenseNumber = ""
        }
        UserManager.shared().saveActiveUser()
    }
    
    func getPreferredLocations(shouldShowKeyboard:Bool = false) {
        self.view.endEditing(true)
        if shouldShowKeyboard { self.showLoader() }
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
                    self.preferredLocations.append(PreferredLocation(preferredLocation: location))
                }
                self.preferredJobLocationPickerView.setup(preferredLocations: self.preferredLocations)
                self.preferredJobLocationPickerView.pickerView.reloadAllComponents()
                self.preferredJobLocationPickerView.backgroundColor = UIColor.white
                if shouldShowKeyboard {
                    if let cell = self.publicProfileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as?
                        EditPublicProfileTableCell {
                        cell.preferredJobLocationTextField.becomeFirstResponder()
                    }
                }
            } else {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
            }
        }
    }
}
