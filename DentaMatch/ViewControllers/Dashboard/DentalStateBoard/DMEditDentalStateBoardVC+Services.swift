//
//  DMEditDentalStateBoardVC+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 24/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON
extension DMEditDentalStateBoardVC {
    
    func uploadDentalStateboardImage()  {
        
        var params = [String:AnyObject]()
        params["type"] = "dental_state_board" as AnyObject?
        if let dentalStateBoardImage = self.dentalStateBoardImage {
            if let imageData = UIImageJPEGRepresentation(dentalStateBoardImage, 0.5) {
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
                self.dentalStateBoardImageURL = response[Constants.ServerKey.result][Constants.ServerKey.profileImageURL].stringValue
                self.updateProfileScreen()
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
                _ = self.navigationController?.popViewController(animated: true)
            } else {
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
}
