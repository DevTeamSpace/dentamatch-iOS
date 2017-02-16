//
//  AppDelegate+Notifications.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 29/11/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import UserNotifications

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
                    print((error?.localizedDescription)!)
                }
                if granted {
                    print("Permission granted")
                   // let pushSettings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
                   // UIApplication.shared.registerUserNotificationSettings(pushSettings)
                    UIApplication.shared.registerForRemoteNotifications()
//                    UIApplication.shared.registerForRemoteNotifications()
                } else {
                    print("Permission not granted")
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
        UserDefaultsManager.sharedInstance.deviceToken = token
    }
    
    //MARK:- Remote/Local Notification Delegates
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //
        debugPrint(error.localizedDescription)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        let dict = userInfo["aps"]
        print(dict ?? "not avail")
        debugPrint("didReceiveRemoteNotification \(userInfo.description)")
        self.window?.makeToast(userInfo.description)

    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let dict = response.notification.request.content.userInfo
        print(dict)
        debugPrint("Go to chat")
        completionHandler()
    }
}
