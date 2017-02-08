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
        //2017-02-07 09:50:39
        DispatchQueue.global(qos: .background).async {
            for chatListObj in chatList! {
                if let chat = self.chatListExits(messageListId: chatListObj["messageListId"].stringValue) {
                    //Update Record
                    chat.lastMessage = chatListObj["message"].stringValue
                    chat.recruiterId = chatListObj["recruiterId"].stringValue
                    chat.isBlockedFromRecruiter = chatListObj["recruiterBlock"].boolValue
                    chat.isBlockedFromSeeker = chatListObj["seekerBlock"].boolValue
                    chat.date = self.getDate(dateString: chatListObj["timestamp"].stringValue)?.date as NSDate?
                    chat.dateString = chatListObj["timestamp"].stringValue
                    chat.officeName = chatListObj["name"].stringValue
                    chat.lastMessageId = chatListObj["messageId"].stringValue
                } else {
                    //New Record
                    let chat = NSEntityDescription.insertNewObject(forEntityName: "ChatList", into: self.context) as! ChatList
                    chat.lastMessage = chatListObj["message"].stringValue
                    chat.recruiterId = chatListObj["recruiterId"].stringValue
                    chat.isBlockedFromRecruiter = chatListObj["recruiterBlock"].boolValue
                    chat.isBlockedFromSeeker = chatListObj["seekerBlock"].boolValue
                    chat.date = self.getDate(dateString: chatListObj["timestamp"].stringValue)?.date as NSDate?
                    chat.dateString = chatListObj["timestamp"].stringValue
                    chat.officeName = chatListObj["name"].stringValue
                    chat.messageListId = chatListObj["messageListId"].stringValue
                    chat.lastMessageId = chatListObj["messageId"].stringValue

                }
            }
            
            DispatchQueue.main.async {
                self.appDelegate.saveContext()
            }
        }
    }
    
    func getDate(dateString:String) -> (date:Date,dateString:String)? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.dateFormatYYYYMMDDHHMMSS()
        let date = dateFormatter.date(from: dateString)
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        if let date = date {
            return (date,dateFormatter.string(from: date))
        }
        return nil
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
    
//    class func updateThoughtNameById(thoughtId:String,thoughtName:String) {
//        let fetchRequest = NSFetchRequest(entityName: "Thought")
//        let predicate = NSPredicate(format: "id == %@", thoughtId)
//        fetchRequest.predicate = predicate
//        do {
//            let thoughts = try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as! [Thought]
//            if thoughts.count > 0 {
//                thoughts[0].name = thoughtName
//            }
//            appDelegate.saveContext()
//        }
//        catch let error as NSError{
//            DDLogVerbose(error.localizedDescription)
//        }
//    }

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
                
//                let when = DispatchTime.now() + 0.2 // change 2 to desired number of seconds
//                DispatchQueue.main.asyncAfter(deadline: when) {
//                    self.messageListTableView.scrollToRow(at: newIndexPath!, at: .bottom, animated: true)
//                    
//                }
            }
        case .update:
            messageListTableView.reloadRows(at: [indexPath!], with: .none)
            
        case .move:
            if let indexPath = indexPath {
                messageListTableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                messageListTableView.insertRows(at: [newIndexPath], with: .fade)
            }
        default:
            break;
            
        }
    }
}
