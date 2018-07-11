//
//  DMMessagesVC+DBHandling.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 07/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import CoreData
import Foundation
import SwiftyJSON

extension DMMessagesVC: NSFetchedResultsControllerDelegate {
    func addUpdateMessageToDB(chatList: [JSON]?) {
        for chatListObj in chatList! {
            if let chat = self.chatListExits(messageListId: chatListObj["messageListId"].stringValue) {
                // Update Record
                chat.lastMessage = chatListObj["message"].stringValue
                chat.recruiterId = chatListObj["recruiterId"].stringValue
                chat.isBlockedFromRecruiter = chatListObj["recruiterBlock"].boolValue
                chat.isBlockedFromSeeker = chatListObj["seekerBlock"].boolValue
                chat.date = getDate(timestamp: chatListObj["timestamp"].stringValue) as NSDate?
                chat.timeStamp = chatListObj["timestamp"].doubleValue
                chat.officeName = chatListObj["name"].stringValue
                chat.lastMessageId = chatListObj["messageId"].stringValue
                chat.unreadCount = chatListObj["unreadCount"].int16Value
            } else {
                // New Record
                if let chat = NSEntityDescription.insertNewObject(forEntityName: "ChatList", into: context) as? ChatList {
                    chat.lastMessage = chatListObj["message"].stringValue
                    chat.recruiterId = chatListObj["recruiterId"].stringValue
                    chat.isBlockedFromRecruiter = chatListObj["recruiterBlock"].boolValue
                    chat.isBlockedFromSeeker = chatListObj["seekerBlock"].boolValue
                    chat.date = getDate(timestamp: chatListObj["timestamp"].stringValue) as NSDate?
                    chat.timeStamp = chatListObj["timestamp"].doubleValue
                    chat.officeName = chatListObj["name"].stringValue
                    chat.messageListId = chatListObj["messageListId"].stringValue
                    chat.lastMessageId = chatListObj["messageId"].stringValue
                    chat.unreadCount = chatListObj["unreadCount"].int16Value
                }
            }
        }
        appDelegate?.saveContext()
    }

    func getDate(timestamp: String) -> Date {
        let doubleTime = Double(timestamp)
        let lastMessageDate = Date(timeIntervalSince1970: doubleTime! / 1000)
        return lastMessageDate
    }

    func chatListExits(messageListId: String) -> ChatList? {
        let fetchRequest: NSFetchRequest<ChatList> = ChatList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "messageListId == %@", messageListId)
        do {
            let chatLists = try context.fetch(fetchRequest)
            if chatLists.count > 0 {
                return chatLists.first
            }
        } catch _ as NSError {
            // debugPrint(error.localizedDescription)
        }
        return nil
    }

    // MARK: - NSFetchedResultsControllerDelegate

    func controllerWillChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        messageListTableView.beginUpdates()
    }

    func controllerDidChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        messageListTableView.endUpdates()
    }

    func controller(_: NSFetchedResultsController<NSFetchRequestResult>, didChange _: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        // debugPrint(indexPath?.row ?? 0)
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                messageListTableView.insertRows(at: [indexPath], with: .automatic)
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
            break
        }
    }
}
