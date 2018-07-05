//
//  AppDelegate+InitialConfiguration.swift
//  DentaMatch
//
//  Created by Prashant Gautam on 04/07/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import Foundation
import Instabug
import SwiftyJSON

extension AppDelegate {
    func setUpApplication() {
        MixpanelOperations.startSessionForMixpanelWithToken()
        Instabug.start(withToken: kInstaBugKey, invocationEvent: .shake)

        configureCrashlytics()

        configureSocket()

        configureGoogleServices()

        registerForPushNotifications()

        // configureRichNotifications()

        changeNavBarAppearance()

        configureNetworkReachability()
    }

    func setUpApplicationUI(_ application: UIApplication, _ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        if !UserDefaultsManager.sharedInstance.isProfileSkipped {
            if UserDefaultsManager.sharedInstance.isLoggedIn {
                if !UserManager.shared().activeUser.jobTitle!.isEmptyField {
                    goToSuccessPendingScreen()
                } else {
                    goToProfile()
                }
            } else {
                if UserDefaultsManager.sharedInstance.isOnBoardingDone {
                    goToRegistration()
                }
            }
        } else {
            goToDashBoard()
            checkForNotificationTapAction(application, launchOptions)
        }
    }

    private func checkForNotificationTapAction(_ application: UIApplication, _ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        if let remoteNotification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary {
            if remoteNotification.allKeys.count > 0 {
                //                    self.tabIndex = 4
                if let noti = remoteNotification["data"] as? NSDictionary {
                    let megCheck = noti["data"] as! NSDictionary
                    if megCheck["messageId"] != nil {
                        NotificationHandler.notificationHandleforChat(fromId: (megCheck["fromId"] as? String), toId: (megCheck["toId"] as? String), messgaeId: (megCheck["messageId"] as? String), recurterId: (megCheck["recurterId"] as? String))
                    } else {
                        let newObjMSG = noti["jobDetails"]
                        let jobJson = JSON(newObjMSG ?? "")
                        let jobObj = Job(job: jobJson)
                        let newObj = noti["data"]
                        let josnObj = JSON(newObj ?? [:])
                        let userNotiObj = UserNotification(dict: josnObj)
                        NotificationHandler.notificationHandleforBackground(notiObj: userNotiObj, jobObj: jobObj, app: application)
                    }
                }
            }
        }
    }
}
