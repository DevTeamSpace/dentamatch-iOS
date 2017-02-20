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
        case .acceptJob: break
            //open job detail
        case .chatMessgae: break
            //No need any action
        case .completeProfile: break
            //open profile
        case .deleteJob: break
            //No need any action
        case .hired: break
            //open job detail
        case .jobCancellation: break
            //open job detail
        case .verifyDocuments: break
            //open edit profile
        case .other: break
            //No need any action
            
            
        }
        
    }
    class func notificationHandleforBackground(notiObj:UserNotification, app : UIApplication) {
        let notificationType = UserNotificationType(rawValue: notiObj.notificationType!)!

        switch notificationType {
        case .acceptJob: break
        //open job detail
        case .chatMessgae: break
        //No need any action
        case .completeProfile: break
        //open profile
        case .deleteJob: break
        //No need any action
        case .hired: break
        //open job detail
        case .jobCancellation: break
        //open job detail
        case .verifyDocuments: break
        //open edit profile
        case .other: break
            //No need any action
        default: break
            
        }

        
    }
    
    class func openJobDetailScreen(obj:Job) {
        
    }
    class func openEditProfileScreen() {
        
    }

    
    
}
