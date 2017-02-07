//
//  DMMessagesVC+DBHandling.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 07/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import CoreData

extension DMMessagesVC:NSFetchedResultsControllerDelegate {

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
                self.messageListTableView.insertRows(at: [indexPath], with: .bottom)
                
//                let when = DispatchTime.now() + 0.2 // change 2 to desired number of seconds
//                DispatchQueue.main.asyncAfter(deadline: when) {
//                    self.messageListTableView.scrollToRow(at: newIndexPath!, at: .bottom, animated: true)
//                    
//                }
            }
        case .update:
            messageListTableView.reloadRows(at: [indexPath!], with: .none)
        default:
            break;
            
        }
    }
}
