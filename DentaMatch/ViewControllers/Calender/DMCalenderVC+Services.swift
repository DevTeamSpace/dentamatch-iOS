//
//  DMCalenderVC+Services.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 02/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMCalenderVC {
    func getHiredJobsFromServer(month:Int,year:Int, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        var param = [String:AnyObject]()
        if month < 10 {
            param["jobMonth"] = "0\(month)" as AnyObject?
            
        }else{
            param["jobMonth"] = month as AnyObject?
        }
        param["jobYear"] = year as AnyObject?
        
        print("getHiredJobsFromServer Parameters\n\(param.description))")
        
        self.showLoader()
        APIManager.apiPost(serviceName: Constants.API.getHiredJobs, parameters: param) { (response:JSON?, error:NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            guard let _ = response else {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            //            debugPrint(response!)
            
            if response![Constants.ServerKey.status].boolValue {
                let resultDic = response![Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                for calObj in resultDic {
                    let hiredObj = Job(forCalendarjob:calObj)
                    self.hiredList.append(hiredObj)
                }
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
