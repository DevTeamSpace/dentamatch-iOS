//
//  DMMessagesVC+DBHandling.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 07/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

extension DMMessagesVC:NSFetchedResultsControllerDelegate {

    func addUpdateMessageToDB(chatList:[JSON]?) {
        for chatListObj in chatList! {
            if let chat = self.chatListExits(messageListId: chatListObj["messageListId"].stringValue) {
                //Update Record
                chat.lastMessage = chatListObj["message"].stringValue
                chat.recruiterId = chatListObj["recruiterId"].stringValue
                chat.isBlockedFromRecruiter = chatListObj["recruiterBlock"].boolValue
                chat.isBlockedFromSeeker = chatListObj["seekerBlock"].boolValue
                chat.date = self.getDate(timestamp: chatListObj["timestamp"].stringValue) as NSDate?
                chat.timeStamp = chatListObj["timestamp"].doubleValue
                chat.officeName = chatListObj["name"].stringValue
                chat.lastMessageId = chatListObj["messageId"].stringValue
                chat.unreadCount = chatListObj["unreadCount"].int16Value
            } else {
                //New Record
                let chat = NSEntityDescription.insertNewObject(forEntityName: "ChatList", into: self.context) as! ChatList
                chat.lastMessage = chatListObj["message"].stringValue
                chat.recruiterId = chatListObj["recruiterId"].stringValue
                chat.isBlockedFromRecruiter = chatListObj["recruiterBlock"].boolValue
                chat.isBlockedFromSeeker = chatListObj["seekerBlock"].boolValue
                chat.date = self.getDate(timestamp: chatListObj["timestamp"].stringValue) as NSDate?
                chat.timeStamp = chatListObj["timestamp"].doubleValue
                chat.officeName = chatListObj["name"].stringValue
                chat.messageListId = chatListObj["messageListId"].stringValue
                chat.lastMessageId = chatListObj["messageId"].stringValue
                chat.unreadCount = chatListObj["unreadCount"].int16Value
                
            }
        }
        self.appDelegate.saveContext()
    }
    
    func getDate(timestamp:String) -> Date {
//        Date.getTodaysDateMMDDYYYY()
        
//        dateFormatter.dateFormat = Date.dateFormatMMDDYYYY()
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        return dateFormatter.date(from: dateFormatter.string(from: todaysDate))!
        
        let doubleTime = Double(timestamp)
        let lastMessageDate = Date(timeIntervalSince1970: doubleTime!/1000)
       // let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        dateFormatter.dateFormat = Date.dateFormatMMDDYYYY()
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
//        let date1 = dateFormatter.string(from: lastMessageDate)

        
        return lastMessageDate
    }
    
    func chatListExits(messageListId:String) -> ChatList? {
        let fetchRequest:NSFetchRequest<ChatList> = ChatList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "messageListId == %@", messageListId)
        do {
            let chatLists = try context.fetch(fetchRequest)
            if chatLists.count > 0 {
                return chatLists.first
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }

    //MARK:- NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.messageListTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.messageListTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        print(indexPath?.row ?? 0)
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                self.messageListTableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            messageListTableView.reloadRows(at: [indexPath!], with: .none)
            
        case .move:
            if let indexPath = indexPath {
                messageListTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            if let newIndexPath = newIndexPath {
                messageListTableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        default:
            break;
            
        }
    }
}
