//
//  NotificationHandler.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 17/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import SwiftyJSON

class NotificationHandler: NSObject {
    class func notificationHandleforForground(notiObj:UserNotification,jobObj:Job?, app : UIApplication) {
        let notificationType = UserNotificationType(rawValue: notiObj.notificationType!)!

        switch notificationType {
        case .acceptJob:
            //open job detail
            openJobDetailScreen(obj: jobObj!)
        case .chatMessgae: break
            //No need any action
        case .completeProfile:
            //open profile
        openEditProfileScreen()

        case .deleteJob:
            //No need any action
            openNotificationScreen()

        case .hired:
            //open job detail
        openJobDetailScreen(obj: jobObj!)

        case .jobCancellation:
            //open job detail
        openJobDetailScreen(obj: jobObj!)

        case .verifyDocuments:
            //open edit profile
            openEditProfileScreen()

        case .other,.InviteJob:
            //No need any action
            openNotificationScreen()
            
            
        }
        
    }
    class func notificationHandleforBackground(notiObj:UserNotification,jobObj:Job?, app : UIApplication) {
        let notificationType = UserNotificationType(rawValue: notiObj.notificationType!)!
        
        switch notificationType {
        case .acceptJob:
            //open job detail
            openJobDetailScreenForBackGround(obj: notiObj.jobdetail!)
            
        case .chatMessgae: break
        //No need any action
        case .completeProfile:
            //open profile
            openEditProfileScreenForBackground()
            
        case .deleteJob:
        //No need any action
            openNotificationScreenInBackGround()

        case .hired:
            //open job detail
            openJobDetailScreenForBackGround(obj: jobObj!)
            
        case .jobCancellation:
            //open job detail
            openJobDetailScreenForBackGround(obj: jobObj!)
            
        case .verifyDocuments:
            //open edit profile
            openEditProfileScreenForBackground()
        case .other,.InviteJob:
            //No need any action
            openNotificationScreenInBackGround()
            
        }
        
        
    }
    
    class func notificationHandleforChat(fromId:String?,toId:String?,messgaeId:String?,recurterId:String?) {
        delay(time: 3.0) {
            if let tabbar = ((UIApplication.shared.delegate) as! AppDelegate).window?.rootViewController as? TabBarVC {
                tabbar.selectedIndex = 3
            }
        }

    }
    
    class func notificationHandleforChatForGround(fromId:String?,toId:String?,messgaeId:String?,recurterId:String?) {
            if let tabbar = ((UIApplication.shared.delegate) as! AppDelegate).window?.rootViewController as? TabBarVC {
                tabbar.selectedIndex = 3
        }
    }
    
    class func openJobDetailScreen(obj:Job) {
        NotificationCenter.default.post(name: .pushRedirectNotificationForground, object: nil, userInfo: ["notificationData":obj])
    }
    class func openEditProfileScreen() {
        if let tabbar = ((UIApplication.shared.delegate) as! AppDelegate).window?.rootViewController as? TabBarVC {
//            _=self.navigationController?.popToRootViewController(animated: false)
            tabbar.selectedIndex = 4
        }

        NotificationCenter.default.post(name: .pushRedirectNotificationForProfile, object: nil, userInfo: nil)
    }
    
    class func openJobDetailScreenForBackGround(obj:Job) {
        delay(time: 3.0) { 
            NotificationCenter.default.post(name: .pushRedirectNotificationForground, object: nil, userInfo: ["notificationData":obj])
        }
    }
    class func openEditProfileScreenForBackground() {
        delay(time: 3.0) { 
            NotificationCenter.default.post(name: .pushRedirectNotificationForProfile, object: nil, userInfo: nil)
        }
    }
    class func openNotificationScreen() {
        //pushRedirectNotificationAllForground
        NotificationCenter.default.post(name: .pushRedirectNotificationAllForground, object: nil, userInfo: nil)
    }
    class func openNotificationScreenInBackGround() {
        delay(time: 3.0) {
            NotificationCenter.default.post(name: .pushRedirectNotificationAllBackGround, object: nil, userInfo: nil)
        }
    }
    
    class func delay(time:TimeInterval,completionHandler: @escaping ()->()) {
        let when = DispatchTime.now() + 0.01
        DispatchQueue.main.asyncAfter(deadline: when) {
            completionHandler()
        }
    }

    
//    class func openNotificationScreen() {
//        NotificationCenter.default.post(name: .pushRedirectNotificationAllForground, object: nil, userInfo: nil)
//    }
//    
//    class func openNotificationScreenForBackGround(obj:Job) {
//        delay(time: 3.0) {
//            NotificationCenter.default.post(name: .pushRedirectNotificationAllBackGround, object: nil, userInfo: nil)
//        }
//    }
    
    
}
