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
import RealmSwift

extension DMMessagesVC: NSFetchedResultsControllerDelegate {
    func addUpdateMessageToDB(chatList: [JSON]?) {
        guard let chatList = chatList else { return }
        
        let realm = try! Realm()
        try! realm.write {
            
            realm.add(chatList.map({
                
                let model = ChatListModel(chatListObj: $0)
                model.date = getDate(timestamp: $0["timestamp"].stringValue)
                return model
            }), update: true)
        }
    }

    func getDate(timestamp: String) -> Date {
        let doubleTime = Double(timestamp)
        let lastMessageDate = Date(timeIntervalSince1970: doubleTime! / 1000)
        return lastMessageDate
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
        case .delete:
            if let indexPath = indexPath {
                messageListTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
