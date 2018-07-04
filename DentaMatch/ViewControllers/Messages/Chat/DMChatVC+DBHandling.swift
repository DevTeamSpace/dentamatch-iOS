//
//  DMChatVC+DBHandling.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 11/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

extension DMChatVC:NSFetchedResultsControllerDelegate {

    func addUpdateChatToDB(chatObj:JSON?) {
        if let chatObj = chatObj {
            if let _ = chatExits(messageId: chatObj["messageId"].stringValue) {
                //Update chat
                ////debugPrint("Update Chat")
                
            } else {
                //New chat
                let chat = NSEntityDescription.insertNewObject(forEntityName: "Chat", into: self.context) as! Chat
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
                        //Sender's Chat
                        if let chatList = DatabaseManager.chatListExists(recruiterId: chatObj["toId"].stringValue) {
                            chatList.lastMessage = chatObj["message"].stringValue
                            chatList.lastMessageId = chatObj["messageId"].stringValue
                            chatList.timeStamp = chatObj["sentTime"].doubleValue
                            chatList.date = Date.getDate(timestamp: chatObj["sentTime"].stringValue) as NSDate?
                            //TODO:- Time Handling
                        }
                    } else {
                        //Recruiter's Chat
                        if let chatList = DatabaseManager.chatListExists(recruiterId: chatObj["fromId"].stringValue) {
                            chatList.lastMessage = chatObj["message"].stringValue
                            chatList.lastMessageId = chatObj["messageId"].stringValue
                            chatList.timeStamp = chatObj["sentTime"].doubleValue
                            chatList.date = Date.getDate(timestamp: chatObj["sentTime"].stringValue) as NSDate?
                            if self.chatList?.recruiterId != chatList.recruiterId {
                                chatList.unreadCount = chatList.unreadCount + 1
                                //Someone other messaged than the one whose chat page is opened
                                
                                ToastView.showNotificationToast(message: chatObj["message"].stringValue, name: chatObj["fromName"].stringValue, imageUrl: "", type: .White, onCompletion: {
                                    self.notificationTapHandling(recruiterId: chatObj["fromId"].stringValue)
                                })
                            }
                        }
                    }
                }
                
                
                
//                self.chatList?.lastMessage = chatObj["message"].stringValue
               // self.chatList?.lastMessageId = chatObj["messageId"].stringValue
            }
        }
        kAppDelegate.saveContext()        
    }
    
    func chatExits(messageId:String) -> Chat? {
        let fetchRequest:NSFetchRequest<Chat> = Chat.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "chatId == %@", messageId)
        do {
            let chats = try context.fetch(fetchRequest)
            if chats.count > 0 {
                return chats.first
            }
        } catch let error as NSError {
            //debugPrint(error.localizedDescription)
        }
        return nil
    }
    
    func getChats() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
        
        let userId = UserManager.shared().activeUser.userId
        let recruiterId = chatList?.recruiterId
        
        fetchRequest.predicate = NSPredicate(format: "(fromId == %@ AND toId == %@) or (fromId == %@ AND toId == %@)",userId!,recruiterId!,recruiterId!,userId!)
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "chatId", ascending: true)
        //let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        //fetchRequest.fetchBatchSize = 20
        
        // Initialize Fetched Results Controller
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "dateString", cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
            DispatchQueue.main.async {
                self.chatTableView.reloadData()
                self.scrollTableToBottom()
            }

        } catch {
            let fetchError = error as NSError
            //debugPrint("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    func scrollTableToBottom() {
        if fetchedResultsController != nil {
            if let sections = fetchedResultsController.sections {
                if sections.count > 0 {
                    let sectionInfo = sections[sections.count - 1]
                    if (sectionInfo.objects?.count)! > 0 {
                        self.chatTableView.scrollToRow(at:IndexPath(row: (sectionInfo.objects?.count)! - 1, section: sections.count - 1), at: .bottom, animated: false)
                    }
                }
            }
        }
    }
    
    //MARK:- NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.chatTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.chatTableView.endUpdates()
        //self.chatTableView.reloadData()

    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            self.chatTableView.insertSections([sectionIndex], with: .automatic)
        case .delete:
            self.chatTableView.deleteSections([sectionIndex], with: .automatic)
        default:
            break
        }
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                self.chatTableView.insertRows(at: [indexPath], with: .none)
                let when = DispatchTime.now() + 0.1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.chatTableView.scrollToRow(at: newIndexPath!, at: .bottom, animated: true)
                }
            }
        case .update:
            chatTableView.reloadRows(at: [indexPath!], with: .none)
            
        case .move:
            if let indexPath = indexPath {
                chatTableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                chatTableView.insertRows(at: [newIndexPath], with: .fade)
            }
        default:
            break;
            
        }
    }
}
