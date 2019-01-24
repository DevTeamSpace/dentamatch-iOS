//
//  UserNotification.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 10/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import SwiftyJSON
import UIKit

class UserNotification: NSObject {
    var createdAtTime = ""
    var notificationID: Int?
    var jobId = ""
    var message = ""
    var notificationType: Int?
    var seen: Int?
    var senderID: Int?
    var reciverID: Int?
    var jobdetail: Job?
    var currentAvailability: [String] = [String]()
    
    override init() {
        /* For Default object of class */
    }

    init(dict: JSON) {
        createdAtTime = dict["createdAt"].stringValue
        notificationID = dict["id"].intValue
        jobId = dict["jobListId"].stringValue
        message = dict["notificationData"].stringValue
        notificationType = dict["notificationType"].intValue
        seen = dict["seen"].intValue
        senderID = dict["senderId"].intValue
        reciverID = dict["receiverId"].intValue
        jobdetail = Job(forCalendarjob: dict["jobDetails"])
        if let availabilityDates = dict["currentAvailability"].arrayObject as? [String] {
            currentAvailability = availabilityDates
        }
    }
}
