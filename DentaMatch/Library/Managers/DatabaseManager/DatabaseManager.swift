//
//  DatabaseManager.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 07/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import CoreData
import SwiftyJSON
import UIKit

class DatabaseManager: NSObject {
//    static let sharedInstance = DatabaseManager()

    class func clearDB() {
        clearChatList()
        clearChats()
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil)
        kAppDelegate?.saveContext()
    }

    private class func clearChatList() {
        let fetchRequest: NSFetchRequest<ChatList> = ChatList.fetchRequest()
        do {
            let chatLists = try kAppDelegate?.managedObjectContext.fetch(fetchRequest)
            for chatList in chatLists! {
                kAppDelegate?.managedObjectContext.delete(chatList)
            }
            kAppDelegate?.saveContext()
        } catch _ as NSError {
            // debugPrint(error.localizedDescription)
        }
    }

    private class func clearChats() {
        let fetchRequest: NSFetchRequest<Chat> = Chat.fetchRequest()
        do {
            let chats = try kAppDelegate?.managedObjectContext.fetch(fetchRequest)
            for chat in chats! {
                kAppDelegate?.managedObjectContext.delete(chat)
            }
            kAppDelegate?.saveContext()
        } catch _ as NSError {
            // debugPrint(error.localizedDescription)
        }
    }

    class func addUpdateChatToDB(chatObj: JSON?) {
        if let chatObj = chatObj {
            if let _ = chatExits(messageId: chatObj["messageId"].stringValue) {
                // Update chat
                // debugPrint("Update Chat")

            } else {
                // New chat
                guard let chat = NSEntityDescription.insertNewObject(forEntityName: "Chat", into: (kAppDelegate?.managedObjectContext)!) as? Chat else {return}
                chat.chatId = chatObj["messageId"].int64Value
                chat.message = chatObj["message"].stringValue
                chat.fromId = chatObj["fromId"].stringValue
                chat.toId = chatObj["toId"].stringValue
                chat.timeStamp = chatObj["sentTime"].doubleValue
                let filteredDateTime = DatabaseManager.getDate(timestamp: chatObj["sentTime"].doubleValue)
                chat.timeString = filteredDateTime.time
                chat.dateString = filteredDateTime.date

                if let user = UserManager.shared().activeUser {
                    if chatObj["fromId"].stringValue == user.userId {
                        // Sender's Chat
                        if let chatList = chatListExists(recruiterId: chatObj["toId"].stringValue) {
                            chatList.lastMessage = chatObj["message"].stringValue
                            chatList.lastMessageId = chatObj["messageId"].stringValue
                            chatList.timeStamp = chatObj["sentTime"].doubleValue
                            // TODO: - Time Handling
                        }
                    } else {
                        // Recruiter's Chat
                        if let chatList = chatListExists(recruiterId: chatObj["fromId"].stringValue) {
                            chatList.lastMessage = chatObj["message"].stringValue
                            chatList.lastMessageId = chatObj["messageId"].stringValue
                            chatList.timeStamp = chatObj["sentTime"].doubleValue
                            chatList.unreadCount = chatList.unreadCount + 1

                            ToastView.showNotificationToast(message: chatObj["message"].stringValue, name: chatObj["fromName"].stringValue, imageUrl: "", type: .White, onCompletion: {
                                kAppDelegate?.chatSocketNotificationTap(recruiterId: chatObj["fromId"].stringValue)
                            })
                        }
                    }
                }
            }
        }
        kAppDelegate?.saveContext()
    }

    class func updateReadCount(recruiterId: String) {
        if recruiterId != "0" {
            if let chatList = chatListExists(recruiterId: recruiterId) {
                chatList.unreadCount = 0
            }
            kAppDelegate?.saveContext()
        }
    }

    class func chatExits(messageId: String) -> Chat? {
        let fetchRequest: NSFetchRequest<Chat> = Chat.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "chatId == %@", messageId)
        do {
            let chats = try kAppDelegate?.managedObjectContext.fetch(fetchRequest)
            if (chats?.count)! > 0 {
                return chats?.first
            }
        } catch _ as NSError {
            // debugPrint(error.localizedDescription)
        }
        return nil
    }

    class func chatListExists(recruiterId: String) -> ChatList? {
        let fetchRequest: NSFetchRequest<ChatList> = ChatList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "recruiterId == %@", recruiterId)
        do {
            let chatLists = try kAppDelegate?.managedObjectContext.fetch(fetchRequest)
            if (chatLists?.count)! > 0 {
                return chatLists?.first
            }
        } catch _ as NSError {
            // debugPrint(error.localizedDescription)
        }
        return nil
    }

    class func getCountForChats(recruiterId: String) -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
        let userId = UserManager.shared().activeUser.userId
        fetchRequest.predicate = NSPredicate(format: "(fromId == %@ AND toId == %@) or (fromId == %@ AND toId == %@)", userId!, recruiterId, recruiterId, userId!)
        do {
            let chatList = try kAppDelegate?.managedObjectContext.fetch(fetchRequest)
            return chatList!.count
        } catch _ as NSError {
            // debugPrint(error.localizedDescription)
        }
        return 0
    }

    class func insertChats(chats: [JSON]?) {
        if let chats = chats {
            for chatObj in chats {
                if let _ = chatExits(messageId: chatObj["messageId"].stringValue) {
                    // Update chat
                    // debugPrint("Update Chat")

                } else {
                    // New chat
                    guard let chat = NSEntityDescription.insertNewObject(forEntityName: "Chat", into: (kAppDelegate?.managedObjectContext)!) as? Chat else {return}
                    chat.chatId = chatObj["messageId"].int64Value
                    chat.message = chatObj["message"].stringValue
                    chat.fromId = chatObj["fromId"].stringValue
                    chat.toId = chatObj["toId"].stringValue
                    chat.timeStamp = chatObj["sentTime"].doubleValue
                    let filteredDateTime = DatabaseManager.getDate(timestamp: chatObj["sentTime"].doubleValue)
                    chat.timeString = filteredDateTime.time
                    chat.dateString = filteredDateTime.date

                    if let user = UserManager.shared().activeUser {
                        if chatObj["fromId"].stringValue == user.userId {
                            // Sender's Chat
                            if let chatList = chatListExists(recruiterId: chatObj["toId"].stringValue) {
                                chatList.lastMessage = chatObj["message"].stringValue
                                chatList.lastMessageId = chatObj["messageId"].stringValue
                                chatList.timeStamp = chatObj["sentTime"].doubleValue
                                // TODO: - Time Handling
                            }
                        } else {
                            // Recruiter's Chat
                            if let chatList = chatListExists(recruiterId: chatObj["fromId"].stringValue) {
                                chatList.lastMessage = chatObj["message"].stringValue
                                chatList.lastMessageId = chatObj["messageId"].stringValue
                                chatList.timeStamp = chatObj["sentTime"].doubleValue
                            }
                        }
                    }
                }
            }
            kAppDelegate?.saveContext()
        }
    }

    class func insertNewMessageListObj(chatObj: JSON) {
        if let _ = chatListExists(recruiterId: chatObj["recruiterId"].stringValue) {
            // Update chat
            // debugPrint("Update Chat")
        } else {
            // New chat
            guard let chatList = NSEntityDescription.insertNewObject(forEntityName: "ChatList", into: (kAppDelegate?.managedObjectContext)!) as? ChatList else {return}
            chatList.lastMessage = chatObj["message"].stringValue
            chatList.recruiterId = chatObj["recruiterId"].stringValue
            chatList.isBlockedFromRecruiter = chatObj["recruiterBlock"].boolValue
            chatList.isBlockedFromSeeker = chatObj["seekerBlock"].boolValue
            chatList.date = getMessageDate(timestamp: chatObj["timestamp"].stringValue) as NSDate?
            chatList.timeStamp = chatObj["timestamp"].doubleValue
            chatList.officeName = chatObj["name"].stringValue
            chatList.messageListId = chatObj["messageListId"].stringValue
            chatList.lastMessageId = chatObj["messageId"].stringValue
            chatList.unreadCount = 1

            NotificationCenter.default.post(name: .hideMessagePlaceholder, object: nil)

            ToastView.showNotificationToast(message: chatObj["message"].stringValue, name: chatObj["name"].stringValue, imageUrl: "", type: .White, onCompletion: {
                kAppDelegate?.chatSocketNotificationTap(recruiterId: chatObj["recruiterId"].stringValue)
            })
        }
        kAppDelegate?.saveContext()
        addChatForFirstTimeMessage(chatObj: chatObj)
    }

    class func addChatForFirstTimeMessage(chatObj: JSON?) {
        if let chatObj = chatObj {
            if let _ = chatExits(messageId: chatObj["messageId"].stringValue) {
                // Update chat
                // debugPrint("Update Chat")

            } else {
                // New chat
                guard let chat = NSEntityDescription.insertNewObject(forEntityName: "Chat", into: (kAppDelegate?.managedObjectContext)!) as? Chat else {return}
                chat.chatId = chatObj["messageId"].int64Value
                chat.message = chatObj["message"].stringValue
                chat.fromId = chatObj["recruiterId"].stringValue

                if let user = UserManager.shared().activeUser {
                    chat.toId = user.userId
                    chat.timeStamp = chatObj["timestamp"].doubleValue
                    let filteredDateTime = DatabaseManager.getDate(timestamp: chatObj["timestamp"].doubleValue)
                    chat.timeString = filteredDateTime.time
                    chat.dateString = filteredDateTime.date
                }
                // debugPrint("New Chat Saved")
            }
        }
        kAppDelegate?.saveContext()
    }

    class func getDate(timestamp: Double) -> (time: String, date: String) {
        let date = Date(timeIntervalSince1970: timestamp / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        dateFormatter.dateFormat = Date.dateFormatYYYYMMDDHHMMSSAA()

        dateFormatter.dateFormat = Date.dateFormatHHMM()
        let dateEnter1 = dateFormatter.string(from: date)
        dateFormatter.dateFormat = Date.dateFormatMMDDYYYY()
        let dateEnter2 = dateFormatter.string(from: date)
        return (dateEnter1, dateEnter2)
    }

    class func getMessageDate(timestamp: String) -> Date {
        let doubleTime = Double(timestamp)
        let lastMessageDate = Date(timeIntervalSince1970: doubleTime! / 1000)
        return lastMessageDate
    }
}
