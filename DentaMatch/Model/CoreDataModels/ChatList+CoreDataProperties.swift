//
//  ChatList+CoreDataProperties.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 21/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import CoreData
import Foundation

extension ChatList1 {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatList1> {
        return NSFetchRequest<ChatList1>(entityName: "ChatList")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var isBlockedFromRecruiter: Bool
    @NSManaged public var isBlockedFromSeeker: Bool
    @NSManaged public var lastMessage: String?
    @NSManaged public var lastMessageId: String?
    @NSManaged public var messageListId: String?
    @NSManaged public var officeName: String?
    @NSManaged public var recruiterId: String?
    @NSManaged public var timeStamp: Double
    @NSManaged public var unreadCount: Int16
}
