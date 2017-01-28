//
//  DMCalendarSetAvailabillityVC+Services.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 28/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON
extension DMCalendarSetAvailabillityVC {
    
    func setMyAvailabilityOnServer(completionHandler: @escaping (JSON?, NSError?) -> ()) {
        var param = [String:AnyObject]()
        param["isFulltime"] = self.isJobTypeFullTime! as AnyObject?
        param["partTimeDays"] = partTimeJobDays as AnyObject?
        param["tempdDates"] = tempJobDays as AnyObject?

        print("setMyAvailabilityOnServer Parameters\n\(param.description))")
        
        self.showLoader()
        APIManager.apiPostWithJSONEncode(serviceName: Constants.API.setAvailabality, parameters: param) { (response:JSON?, error:NSError?) in
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
                //                let resultArray = response![Constants.ServerKey.result][Constants.ServerKey.list].array
                //                if (resultArray?.count)! > 0
                //                {
                //                    let dict  = resultArray?[0].dictionary
                //                    self.currentExperience?.experienceID = (dict?[Constants.ServerKey.experienceId]?.intValue)!
                //                }
                
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                //do next
                completionHandler(response, error)
                
            } else {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                completionHandler(response, error)
                
            }
        }
    }
 
}
