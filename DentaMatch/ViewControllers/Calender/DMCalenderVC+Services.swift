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
    func getHiredJobsFromServer(date:Date, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
//        let firstDate  = Date.getMonthBasedOnThis(date1: Date(), duration: -3)
//        let lastDate  = Date.getMonthBasedOnThis(date1: Date(), duration: 3)
        
        let date5  =  gregorian?.fs_firstDay(ofMonth: date)
        let date2  =  gregorian?.fs_lastDay(ofMonth: date)
        let strStartDate = Date.dateToString(date: date5!)
        let strEndDate = Date.dateToString(date: date2!)

        var param = [String:AnyObject]()
        param["jobStartDate"] = strStartDate as AnyObject?
        param["jobEndDate"] = strEndDate as AnyObject?

//        param["jobYear"] = year as AnyObject?
        
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
            
            debugPrint(response!)
            self.hiredList.removeAll()

            if response![Constants.ServerKey.status].boolValue {
                let resultDic = response![Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                for calObj in resultDic {
                    let hiredObj = Job(forCalendarjob:calObj)
                    self.hiredList.append(hiredObj)
                }
//                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                //do next
                completionHandler(response, error)
                
            } else {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                completionHandler(response, error)
                
            }
        }
    }

    
}
