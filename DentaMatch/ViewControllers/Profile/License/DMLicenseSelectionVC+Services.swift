//
//  DMLicenseSelectionVC+Services.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 11/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON
extension DMLicenseSelectionVC {
    
    func updateLicenseAndStateAPI(params:[String:String]) {
        //debugPrint("LicenseNumberAndState Parameters\n\(params.description))")
        self.showLoader()
        APIManager.apiPut(serviceName: Constants.API.licenseNumberAndState, parameters: params) { (response:JSON?, error:NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            guard let _ = response else {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            //debugPrint(response!)
            
            if response![Constants.ServerKey.status].boolValue {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                //Saving current job title and id
                UserManager.shared().activeUser.jobTitleId = "\(self.selectedJobTitle.jobId)"
                UserManager.shared().activeUser.jobTitleId = "\(self.selectedJobTitle.jobTitle)"
                self.openExperienceFirstScreen()
            } else {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
            }
        }
    }
    
    func uploadDentalStateboardImage()  {
        
        var params = [String:AnyObject]()
        params["type"] = "dental_state_board" as AnyObject?
        if let profileImageData = self.stateBoardImage {
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
                    
                    //debugPrint(response!)
                    self.handleDentalStateBoardResponse(response: response)
                    
                    
                })
            } else {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
            }
        }

    }
    
    func handleDentalStateBoardResponse(response:JSON?) {
        
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                UserDefaultsManager.sharedInstance.licenseImageURL = response[Constants.ServerKey.result][Constants.ServerKey.profileImageURL].stringValue
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            } else {
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
}
