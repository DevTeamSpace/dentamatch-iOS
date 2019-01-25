//
//  DMChatVC+DBHandling.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 11/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import CoreData
import Foundation
import SwiftyJSON

extension DMChatVC: NSFetchedResultsControllerDelegate {
    func addUpdateChatToDB(chatObj: JSON?) {
        
        DatabaseManager.addUpdateChatToDB(chatObj: chatObj)
    }

    func getChats() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")

        let userId = UserManager.shared().activeUser.userId
        let recruiterId = chatList?.recruiterId

        fetchRequest.predicate = NSPredicate(format: "(fromId == %@ AND toId == %@) or (fromId == %@ AND toId == %@)", userId, recruiterId!, recruiterId!, userId)

        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "chatId", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        // Initialize Fetched Results Controller
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "dateString", cacheName: nil)

        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
            DispatchQueue.main.async {
                self.chatTableView.reloadData()
                self.scrollTableToBottom()
            }

        } catch {
            let _ = error as NSError
            // debugPrint("\(fetchError), \(fetchError.userInfo)")
        }
    }

    func scrollTableToBottom() {
        if fetchedResultsController != nil {
            if let sections = fetchedResultsController.sections {
                if sections.count > 0 {
                    let sectionInfo = sections[sections.count - 1]
                    if (sectionInfo.objects?.count)! > 0 {
                        chatTableView.scrollToRow(at: IndexPath(row: (sectionInfo.objects?.count)! - 1, section: sections.count - 1), at: .bottom, animated: false)
                    }
                }
            }
        }
    }

    // MARK: - NSFetchedResultsControllerDelegate

    func controllerWillChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        chatTableView.beginUpdates()
    }

    func controllerDidChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        chatTableView.endUpdates()
        // self.chatTableView.reloadData()
    }

    func controller(_: NSFetchedResultsController<NSFetchRequestResult>, didChange _: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            chatTableView.insertSections([sectionIndex], with: .automatic)
        case .delete:
            chatTableView.deleteSections([sectionIndex], with: .automatic)
        default:
            break
        }
    }

    func controller(_: NSFetchedResultsController<NSFetchRequestResult>, didChange _: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                chatTableView.insertRows(at: [indexPath], with: .none)
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
            break
        }
    }
}
