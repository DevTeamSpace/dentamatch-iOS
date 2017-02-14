//
//  DMNotificationVC+Services.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 08/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMNotificationVC {
    func getNotificationList(completionHandler: @escaping (Bool?, NSError?) -> ()) {
        var params = [String:AnyObject]()
        params["page"] = 1 as AnyObject
        self.showLoader()
        APIManager.apiGet(serviceName: Constants.API.getNotificationList, parameters: params) { (response:JSON?, error:NSError?) in
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
            self.notificationList.removeAll()
            if response![Constants.ServerKey.status].boolValue {
                let resultDic = response![Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                for dictObj in resultDic {
                    let notificationObj = UserNotification(dict: dictObj)
                    self.notificationList.append(notificationObj)
                }

                
//                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                completionHandler(true, error)
                //do next
            } else {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                completionHandler(false, error)
                
            }
        }
    }
    
    
    
    
    
    func readNotificationToServer(notificationObj:UserNotification, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        var param = [String:AnyObject]()
        param["notificationId"] = notificationObj.notificationID as AnyObject?
        
        //        param["jobYear"] = year as AnyObject?
        
        print("readNotification Parameters\n\(param.description))")
        
        self.showLoader()
        APIManager.apiPost(serviceName: Constants.API.readNotification, parameters: param) { (response:JSON?, error:NSError?) in
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
//                let resultDic = response![Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
//                                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                //do next
                completionHandler(response, error)
                
            } else {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                completionHandler(response, error)
                
            }
        }
    }


 
    
}
