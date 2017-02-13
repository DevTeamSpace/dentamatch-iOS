//
//  DatabaseManager.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 07/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import CoreData

class DatabaseManager: NSObject {

//    static let sharedInstance = DatabaseManager()

    class func clearDB() {
        clearChatList()
        clearChats()
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil)
        kAppDelegate.saveContext()
    }
    
    private class func clearChatList() {
        
        let fetchRequest: NSFetchRequest<ChatList> = ChatList.fetchRequest()
        do {
            let chatLists = try kAppDelegate.managedObjectContext.fetch(fetchRequest)
            for chatList in chatLists {
                kAppDelegate.managedObjectContext.delete(chatList)
            }
            kAppDelegate.saveContext()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private class func clearChats() {
        let fetchRequest: NSFetchRequest<Chat> = Chat.fetchRequest()
        do {
            let chats = try kAppDelegate.managedObjectContext.fetch(fetchRequest)
            for chat in chats {
                kAppDelegate.managedObjectContext.delete(chat)
            }
            kAppDelegate.saveContext()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
