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
            if let chat = chatExits(messageId: chatObj["messageId"].stringValue) {
                //Update chat
                
            } else {
                //New chat
                let chat = NSEntityDescription.insertNewObject(forEntityName: "Chat", into: self.context) as! Chat
                chat.chatId = chatObj["messageId"].stringValue
                chat.message = chatObj["message"].stringValue
                chat.fromId = chatObj["fromId"].stringValue
                chat.toId = chatObj["toId"].stringValue
                chat.dateString = chatObj["sentTime"].stringValue
                self.getDate(timestamp: chatObj["sentTime"].stringValue)
                self.chatList?.lastMessage = chatObj["message"].stringValue
                self.chatList?.lastMessageId = chatObj["messageId"].stringValue
                //chat.date = self.getDate(dateString: chatObj["timestamp"].stringValue)?.date as NSDate?
            }
        }
        self.appDelegate.saveContext()
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
            print(error.localizedDescription)
        }
        return nil
    }
    
    func getChats() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "chatId", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        //fetchRequest.fetchBatchSize = 20
        
        // Initialize Fetched Results Controller
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
            self.chatTableView.reloadData()
            self.scrollTableToBottom()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        
    }
    
    func scrollTableToBottom() {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[sections.count - 1]
            if sections.count > 0 {
                if (sectionInfo.objects?.count)! > 0 {
                    self.chatTableView.scrollToRow(at:IndexPath(row: (sectionInfo.objects?.count)! - 1, section: sections.count - 1), at: .bottom, animated: true)
                }
            }
        }

    }
    
    func getDate(timestamp:String) {
        let doubleTime = Double(timestamp)
        let date = Date(timeIntervalSince1970: doubleTime!/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        dateFormatter.dateFormat = Date.dateFormatYYYYMMDDHHMMSSAA()
        let dateEnter = dateFormatter.string(from: date)

        dateFormatter.dateFormat = Date.dateFormatHHMM()
        let dateEnter1 = dateFormatter.string(from: date)

//       dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let ee = dateFormatter.date(from: dateEnter)

    }
    
    //MARK:- NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //self.chatTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //self.chatTableView.endUpdates()
        self.chatTableView.reloadData()

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
