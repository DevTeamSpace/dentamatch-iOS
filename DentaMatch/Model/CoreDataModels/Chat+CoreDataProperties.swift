//
//  Chat+CoreDataProperties.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 17/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import CoreData


extension Chat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chat> {
        return NSFetchRequest<Chat>(entityName: "Chat");
    }

    @NSManaged public var chatId: String?
    @NSManaged public var timeStamp: Double
    @NSManaged public var dateTime: NSDate?
    @NSManaged public var fromId: String?
    @NSManaged public var message: String?
    @NSManaged public var readStatus: Int16
    @NSManaged public var timeString: String?
    @NSManaged public var toId: String?

}
