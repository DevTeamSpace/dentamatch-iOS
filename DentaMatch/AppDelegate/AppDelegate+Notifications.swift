//
//  AppDelegate+Notifications.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 29/11/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

extension AppDelegate {
    
    func registerForPushNotifications() {
        let pushSettings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(pushSettings)
        UIApplication.shared.registerForRemoteNotifications()
    }

    //MARK:- Device Token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count {
            //token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
            token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        debugPrint(token)
    }
    
    //MARK:- Remote/Local Notification Delegates
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    }

}
