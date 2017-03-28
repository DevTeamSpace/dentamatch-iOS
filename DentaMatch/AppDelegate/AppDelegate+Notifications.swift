//
//  AppDelegate+Notifications.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 29/11/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import UserNotifications
import SwiftyJSON

extension AppDelegate:UNUserNotificationCenterDelegate {
    
    func registerForPushNotifications() {
        let pushSettings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(pushSettings)
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func configureRichNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (granted:Bool, error:Error?) in
                
                if error != nil {
                    debugPrint((error?.localizedDescription)!)
                }
                if granted {
                    debugPrint("Permission granted")
                   // let pushSettings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
                   // UIApplication.shared.registerUserNotificationSettings(pushSettings)
                    UIApplication.shared.registerForRemoteNotifications()
//                    UIApplication.shared.registerForRemoteNotifications()
                } else {
                    debugPrint("Permission not granted")
                }
            }
            UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
        }
    }

    
    //MARK:- UIApplicationDelegate
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // application is unused
        var token = ""
        for i in 0..<deviceToken.count {
            //token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
            token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        debugPrint(token)
        if UserDefaultsManager.sharedInstance.deviceToken == token {
            //Nothing needed to call
        } else {
            UserDefaultsManager.sharedInstance.deviceToken = token
            self.updateDeviceTokenAPI()
        }
    }
    
    //MARK:- Remote/Local Notification Delegates
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //
        debugPrint(error.localizedDescription)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        let dict = userInfo["aps"] as? NSDictionary
        debugPrint(dict ?? "not avail")
        debugPrint("didReceiveRemoteNotification \(userInfo.description)")
        //        self.window?.makeToast(userInfo.description)
        
        
        let state: UIApplicationState = UIApplication.shared.applicationState
        
        if(state == UIApplicationState.active)
        {
            
            
            if UserDefaultsManager.sharedInstance.isLoggedIn {
                if let noti = userInfo["data"] as? NSDictionary {
                    let megCheck = noti["data"] as! NSDictionary
                    if megCheck["messageId"] != nil {
                    }else{
                        let noti = userInfo["data"] as? NSDictionary
                        let newObjMSG = noti?["jobDetails"]
                        let jobJson = JSON(newObjMSG ?? [:])
                        let jobObj = Job(job: jobJson)
                        
                        let newObj = noti?["data"]
                        let josnObj = JSON(newObj ?? [:])
                        let userNotiObj = UserNotification(dict: josnObj)
                        ToastView.showNotificationToast(message: userNotiObj.message, name: "Notification", imageUrl: "",  type: ToastSkinType.White, onCompletion:{
                            NotificationHandler.notificationHandleforForground(notiObj: userNotiObj,jobObj:jobObj, app: application)
                            
                        })
                    }
                    
                    
                }
            }
            
            
            
        }else{
            
            if UserDefaultsManager.sharedInstance.isLoggedIn {
                if let noti = userInfo["data"] as? NSDictionary {
                    let megCheck = noti["data"] as! NSDictionary
                    if megCheck["messageId"] != nil {
                        NotificationHandler.notificationHandleforChat(fromId: (megCheck["fromId"] as? String), toId: (megCheck["toId"]  as? String), messgaeId: (megCheck["messageId"]  as? String), recurterId: (megCheck["recurterId"]  as? String))
                        
                    }else{
                        let noti = userInfo["data"] as? NSDictionary
                        let newObjMSG = noti?["jobDetails"]
                        let jobJson = JSON(newObjMSG ?? [:])
                        let jobObj = Job(job: jobJson)
                        
                        let newObj = noti?["data"]
                        let josnObj = JSON(newObj ?? [:])
                        let userNotiObj = UserNotification(dict: josnObj)
                        NotificationHandler.notificationHandleforForground(notiObj: userNotiObj, jobObj:jobObj, app: application)
                        
                    }
                    
                    
                }
            }
            
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let dict = response.notification.request.content.userInfo
        debugPrint(dict)
        debugPrint("Go to chat")
        completionHandler()
    }
    
    func updateDeviceTokenAPI() {
        if let user = UserManager.shared().activeUser {
            let params = [
                "accessToken":user.accessToken,
                "updateDeviceToken":UserDefaultsManager.sharedInstance.deviceToken
            ]
            APIManager.apiPost(serviceName: Constants.API.updateDeviceToken, parameters: params, completionHandler: { (response:JSON?, error:NSError?) in
                debugPrint(response ?? "response not avaialble")
            })
        }
    }
}
