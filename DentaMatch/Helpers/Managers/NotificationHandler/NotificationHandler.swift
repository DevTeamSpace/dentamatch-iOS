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
    class func notificationHandleforForground(notiObj:UserNotification, app : UIApplication) {
        let notificationType = UserNotificationType(rawValue: notiObj.notificationType!)!

        switch notificationType {
        case .acceptJob:
            //open job detail
            openJobDetailScreen(obj: notiObj.jobdetail!)
        case .chatMessgae: break
            //No need any action
        case .completeProfile:
            //open profile
        openEditProfileScreen()

        case .deleteJob: break
            //No need any action
        case .hired:
            //open job detail
        openJobDetailScreen(obj: notiObj.jobdetail!)

        case .jobCancellation:
            //open job detail
        openJobDetailScreen(obj: notiObj.jobdetail!)

        case .verifyDocuments:
            //open edit profile
            openEditProfileScreen()

        case .other: break
            //No need any action
            
            
        }
        
    }
    class func notificationHandleforBackground(notiObj:UserNotification, app : UIApplication) {
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
            
        case .deleteJob: break
        //No need any action
        case .hired:
            //open job detail
            openJobDetailScreenForBackGround(obj: notiObj.jobdetail!)
            
        case .jobCancellation:
            //open job detail
            openJobDetailScreenForBackGround(obj: notiObj.jobdetail!)
            
        case .verifyDocuments:
            //open edit profile
            openEditProfileScreenForBackground()
        case .other: break
            //No need any action
            
        }
        
        
    }
    
    class func openJobDetailScreen(obj:Job) {
        NotificationCenter.default.post(name: .pushRedirectNotificationForground, object: nil, userInfo: ["notificationData":obj])
    }
    class func openEditProfileScreen() {
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
    
    class func delay(time:TimeInterval,completionHandler: @escaping ()->()) {
        let when = DispatchTime.now() + 0.01
        DispatchQueue.main.asyncAfter(deadline: when) {
            completionHandler()
        }
    }

    
    
}
