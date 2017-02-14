//
//  DatabaseManager.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 07/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

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
    
    class func addUpdateChatToDB(chatObj:JSON?) {
        if let chatObj = chatObj {
            if let chat = chatExits(messageId: chatObj["messageId"].stringValue) {
                //Update chat
                
            } else {
                //New chat
                let chat = NSEntityDescription.insertNewObject(forEntityName: "Chat", into: kAppDelegate.managedObjectContext) as! Chat
                chat.chatId = chatObj["messageId"].stringValue
                chat.message = chatObj["message"].stringValue
                chat.fromId = chatObj["fromId"].stringValue
                chat.toId = chatObj["toId"].stringValue
                chat.dateString = chatObj["sentTime"].stringValue
                
                if let user = UserManager.shared().activeUser {
                    if chatObj["fromId"].stringValue == user.userId {
                        //Sender's Chat
                        if let chatList = chatListExists(recruiterId: chatObj["toId"].stringValue) {
                            chatList.lastMessage = chatObj["message"].stringValue
                            chatList.lastMessageId = chatObj["messageId"].stringValue
                            //TODO:- Time Handling
                        }
                    } else {
                        //Recruiter's Chat
                        if let chatList = chatListExists(recruiterId: chatObj["fromId"].stringValue) {
                            chatList.lastMessage = chatObj["message"].stringValue
                            chatList.lastMessageId = chatObj["messageId"].stringValue
                        }
                    }
                }
                //chat.date = self.getDate(dateString: chatObj["timestamp"].stringValue)?.date as NSDate?
            }
        }
        kAppDelegate.saveContext()
    }
    
    class func chatExits(messageId:String) -> Chat? {
        let fetchRequest:NSFetchRequest<Chat> = Chat.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "chatId == %@", messageId)
        do {
            let chats = try kAppDelegate.managedObjectContext.fetch(fetchRequest)
            if chats.count > 0 {
                return chats.first
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
    class func chatListExists(recruiterId:String) -> ChatList? {
        let fetchRequest:NSFetchRequest<ChatList> = ChatList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "recruiterId == %@", recruiterId)
        do {
            let chatLists = try kAppDelegate.managedObjectContext.fetch(fetchRequest)
            if chatLists.count > 0 {
                return chatLists.first
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
