//
//  UserNotification.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 10/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserNotification: NSObject {
    var createdAtTime = ""
    var notificationID:Int?
    var JobId = ""
    var message = ""
    var notificationType:Int?
    var seen:Int?
    var senderID:Int?
    var reciverID:Int?
    var jobdetail:Job?
    
    override init() {
        
    }
    
    init(dict:JSON) {
         self.createdAtTime = dict["createdAt"].stringValue
         self.notificationID = dict["id"].intValue
         self.JobId = dict["jobListId"].stringValue
         self.message = dict["notificationData"].stringValue
         self.notificationType = dict["notificationType"].intValue
         self.seen = dict["seen"].intValue
         self.senderID = dict["senderId"].intValue
         self.reciverID = dict["receiverId"].intValue
        self.jobdetail = Job(forCalendarjob: dict["jobDetails"])
    }

}
