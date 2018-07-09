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
            let pushSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(pushSettings)
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
        // debugPrint(token)
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
        let state: UIApplicationState = UIApplication.shared.applicationState
        if state == UIApplicationState.active {
            if UserDefaultsManager.sharedInstance.isLoggedIn {
                if let megCheck = userInfo["data"] as? NSDictionary {
                    if megCheck["messageId"] != nil {
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
                    
                    if megCheck["messageId"] != nil {
                        NotificationHandler.notificationHandleforChat(fromId: (megCheck["fromId"] as? String), toId: (megCheck["toId"] as? String), messgaeId: (megCheck["messageId"] as? String), recurterId: (megCheck["recurterId"] as? String))
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
            }
        }
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_: UNUserNotificationCenter, willPresent _: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge])
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_: UNUserNotificationCenter, didReceive _: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
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
}
