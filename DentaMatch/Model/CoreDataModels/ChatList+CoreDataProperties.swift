//
//  ChatList+CoreDataProperties.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 17/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import CoreData


extension ChatList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatList> {
        return NSFetchRequest<ChatList>(entityName: "ChatList");
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var timeStamp: Double
    @NSManaged public var isBlockedFromRecruiter: Bool
    @NSManaged public var isBlockedFromSeeker: Bool
    @NSManaged public var lastMessage: String?
    @NSManaged public var lastMessageId: String?
    @NSManaged public var messageListId: String?
    @NSManaged public var officeName: String?
    @NSManaged public var recruiterId: String?

}
