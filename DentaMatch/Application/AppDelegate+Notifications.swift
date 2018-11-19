//
//  AppDelegate+Notifications.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 29/11/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON
import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { _, error in
                if error == nil {
                    DispatchQueue.main.sync {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        
    }

    // MARK: - UIApplicationDelegate

    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // application is unused
        var token = ""
        for i in 0 ..< deviceToken.count {
            token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        LogManager.logDebug(token)
        if UserDefaultsManager.sharedInstance.deviceToken == token {
            // Nothing needed to call
        } else {
            UserDefaultsManager.sharedInstance.deviceToken = token
            updateDeviceTokenAPI()
        }
    }

    // MARK: - Remote/Local Notification Delegates

    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError _: Error) {
        //
        // debugPrint(error.localizedDescription)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        LogManager.logDebug(userInfo.description)
        let state: UIApplicationState = UIApplication.shared.applicationState
        if state == UIApplicationState.active {
            if UserDefaultsManager.sharedInstance.isLoggedIn {
                if let megCheck = userInfo["data"] as? NSDictionary {
                     guard let chatData = megCheck["data"] as? NSDictionary else {return}
                    if chatData["messageId"] != nil {
                        // debugPrint("message check nil")
                    } else {
                        let noti = userInfo["data"] as? NSDictionary
                        let newObjMSG = noti?["jobDetails"]
                        let jobJson = JSON(newObjMSG ?? [:])
                        let jobObj = Job(job: jobJson)
                        let newObj = noti?["data"]
                        let josnObj = JSON(newObj ?? [:])
                        let userNotiObj = UserNotification(dict: josnObj)
                        ToastView.showNotificationToast(message: userNotiObj.message, name: "Notification", imageUrl: "", type: ToastSkinType.White, onCompletion: {
                            NotificationHandler.notificationHandleforForground(notiObj: userNotiObj, jobObj: jobObj, app: application)
                        })
                    }
                }
            }
        } else {
            if UserDefaultsManager.sharedInstance.isLoggedIn {
                if let megCheck = userInfo["data"] as? NSDictionary {
                    guard let chatData = megCheck["data"] as? NSDictionary else {return}
                    if chatData["messageId"] != nil {
                        NotificationHandler.notificationHandleforChat(fromId: (chatData["fromId"] as? String), toId: (chatData["toId"] as? String), messgaeId: (chatData["messageId"] as? String), recurterId: (chatData["recurterId"] as? String))
                    } else {
                        let noti = userInfo["data"] as? NSDictionary
                        let newObjMSG = noti?["jobDetails"]
                        let jobJson = JSON(newObjMSG ?? [:])
                        let jobObj = Job(job: jobJson)
                        let newObj = noti?["data"]
                        let josnObj = JSON(newObj ?? [:])
                        let userNotiObj = UserNotification(dict: josnObj)
                        NotificationHandler.notificationHandleforBackground(notiObj: userNotiObj, jobObj: jobObj, app: application)
                    }
                }
                //NotificationCenter.default.post(name: .decreaseBadgeCount, object: nil, userInfo: nil)
            }
        }
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let dictionaryUserInfo: NSDictionary = notification.request.content.userInfo["data"] as? NSDictionary {
            LogManager.logDebug(notification.request.content.userInfo.description)
            guard let chatData = dictionaryUserInfo["data"] as? NSDictionary else {return}
            if chatData["messageId"] != nil {
                //Do nothing ...
            } else {
                let newObj = dictionaryUserInfo["data"]
                let josnObj = JSON(newObj ?? [:])
                let userNotiObj = UserNotification(dict: josnObj)
                NotificationHandler.notificationHandleforScreenRefresh(notiObj: userNotiObj, jobObj: nil)
               NotificationCenter.default.post(name: .fetchBadgeCount, object: nil, userInfo: nil)
            }
        }
        completionHandler([.alert, .badge])
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let megCheck: NSDictionary = response.notification.request.content.userInfo["data"] as? NSDictionary {
            LogManager.logDebug(response.notification.request.content.userInfo.description)
            LogManager.logDebug(megCheck.description)
            guard let chatData = megCheck["data"] as? NSDictionary else {return}
            if chatData["messageId"] != nil {
                NotificationHandler.notificationHandleforChat(fromId: (chatData["fromId"] as? String), toId: (chatData["toId"] as? String), messgaeId: (chatData["messageId"] as? String), recurterId: (chatData["recurterId"] as? String))
            } else {
                let noti = megCheck
                let newObjMSG = noti["jobDetails"]
                let jobJson = JSON(newObjMSG ?? [:])
                let jobObj = Job(job: jobJson)
                let newObj = noti["data"]
                let josnObj = JSON(newObj ?? [:])
                let userNotiObj = UserNotification(dict: josnObj)
                NotificationHandler.notificationHandleforBackground(notiObj: userNotiObj, jobObj: jobObj)
            }
             //NotificationCenter.default.post(name: .decreaseBadgeCount, object: nil, userInfo: nil)
            completionHandler()
        }
    }

    func updateDeviceTokenAPI() {
        if let user = UserManager.shared().activeUser {
            let params: [String: Any] = [
                "accessToken": user.accessToken,
                "updateDeviceToken": UserDefaultsManager.sharedInstance.deviceToken,
            ]
            APIManager.apiPost(serviceName: Constants.API.updateDeviceToken, parameters: params, completionHandler: { (_: JSON?, _: NSError?) in
                // debugPrint(response ?? "response not avaialble")
            })
        }
    }
    
    // MARK: Badge Count ...
    func resetBadgeCount() {
        UserDefaults.setObject(0 as NSNumber, forKey: Constants.kUnreadCount)
        setIconBadgeOnApp(unreadCount: 0)
    }
    
    func setAppBadgeCount(_ unreadCount: Int) {
        UserDefaults.setObject(unreadCount as NSNumber, forKey: Constants.kUnreadCount)
        setIconBadgeOnApp(unreadCount: unreadCount)
    }
    
    func doNotificationIncrementByOne() {
        if let count = UserDefaults.objectForKey(Constants.kUnreadCount) as! NSNumber? {
            UserDefaults.setObject(count.intValue + 1 as NSNumber, forKey: Constants.kUnreadCount)
            setIconBadgeOnApp(unreadCount: count.intValue + 1)
        }
    }
    
    func setIconBadgeOnApp(unreadCount: Int) {
        UIApplication.shared.applicationIconBadgeNumber = unreadCount
        
    }
    
    func decrementBadgeCount() {
        if let count = UserDefaults.objectForKey(Constants.kUnreadCount) as? NSNumber, count.intValue > 0 {
            UserDefaults.setObject(count.intValue - 1 as NSNumber, forKey: Constants.kUnreadCount)
            setIconBadgeOnApp(unreadCount: count.intValue - 1)
        }
    }
    
    func badgeCount() -> Int {
        if let count = UserDefaults.objectForKey(Constants.kUnreadCount) as? NSNumber, count.intValue > 0 {
            return count.intValue
        }
        return 0
    }
    
}
