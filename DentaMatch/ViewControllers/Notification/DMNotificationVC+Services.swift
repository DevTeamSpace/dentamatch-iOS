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
        params["page"] = self.pageNumber as AnyObject
        debugPrint("notification Parameter \(params)")
        if self.pageNumber == 1 {
            self.showLoader()
        }
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
            if self.pageNumber == 1 {
                self.notificationList.removeAll()
            }
            if response![Constants.ServerKey.status].boolValue {
                let resultDic = response![Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                self.pageNumber = self.pageNumber + 1
                for dictObj in resultDic {
                    let notificationObj = UserNotification(dict: dictObj)
                    self.notificationList.append(notificationObj)
                }

                self.placeHolderEmptyJobsView?.isHidden = self.notificationList.count > 0 ? true : false
                
                self.totalNotificationOnServer = response![Constants.ServerKey.result]["total"].intValue
                //total
//                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                completionHandler(true, error)
                //do next
            } else {
                if response![Constants.ServerKey.statusCode].intValue == 201 {
                    completionHandler(false, error)
                } else {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                completionHandler(false, error)
                }
                
            }
            DispatchQueue.main.async {
//                self.notificationTableView.reloadData()
                self.notificationTableView.tableFooterView = nil
            }

        }
    }
    
    
    
    
    
    func readNotificationToServer(notificationObj:UserNotification, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        var param = [String:AnyObject]()
        param["notificationId"] = notificationObj.notificationID as AnyObject?
        
        //        param["jobYear"] = year as AnyObject?
        
        debugPrint("readNotification Parameters\n\(param.description))")
        
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
    
    func inviteActionSendToServer(notificationObj:UserNotification,actionType:Int, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        
        //actionType 0 = reject ; 1 = accept
        var param = [String:AnyObject]()
        param["notificationId"] = notificationObj.notificationID as AnyObject?
        param["acceptStatus"] = actionType as AnyObject?

        debugPrint("readNotification Parameters\n\(param.description))")
        
        self.showLoader()
        APIManager.apiPost(serviceName: Constants.API.acceptRejectNotification, parameters: param) { (response:JSON?, error:NSError?) in
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
                //do next
                completionHandler(response, error)
                
            } else {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                completionHandler(response, error)
                
            }
        }
    }

    func deleteNotification(notificationObj:UserNotification,completionHandler: @escaping (Bool?, NSError?) -> ()) {
        var params = [String:AnyObject]()
        params["notificationId"] = notificationObj.notificationID  as AnyObject?
        debugPrint("delete notification Parameters\n\(params.description))")
        
        self.showLoader()
        APIManager.apiPost(serviceName: Constants.API.deleteNotification, parameters: params) { (response:JSON?, error:NSError?) in
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
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                completionHandler(true, error)
                //do next
            } else {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                completionHandler(false, error)
                
            }
        }
    }



 
    
}
