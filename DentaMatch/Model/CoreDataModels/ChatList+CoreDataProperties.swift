//
//  ChatList+CoreDataProperties.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 07/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import CoreData


extension ChatList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatList> {
        return NSFetchRequest<ChatList>(entityName: "ChatList");
    }

    @NSManaged public var recruiterId: String?
    @NSManaged public var lastMessage: String?
    @NSManaged public var officeName: String?
    @NSManaged public var dateString: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var isBlockedFromSeeker: Bool
    @NSManaged public var isBlockedFromRecruiter: Bool

}
