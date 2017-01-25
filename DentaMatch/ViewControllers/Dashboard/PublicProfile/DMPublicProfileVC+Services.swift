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
                    print(response!)
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
            print(response!)
        }
    }
    
    func handleUploadProfileResponse(response:JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                UserManager.shared().activeUser.profileImageURL = response[Constants.ServerKey.result][Constants.ServerKey.profileImageURL].stringValue
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
                self.publicProfileTableView.reloadData()
            } else {
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
}
