//
//  DMMessagesVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 22/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import CoreData

class DMMessagesVC: DMBaseVC {

    @IBOutlet weak var messageListTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.getChatListAPI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndex = self.messageListTableView.indexPathForSelectedRow {
            self.messageListTableView.deselectRow(at: selectedIndex, animated: true)
        }
    }
    
    func setup() {
        self.title = "MESSAGES"
        self.messageListTableView.dataSource = nil
        self.messageListTableView.register(UINib(nibName: "MessageListTableCell", bundle: nil), forCellReuseIdentifier: "MessageListTableCell")
    }
    
    func getMessageList() {
        self.messageListTableView.dataSource = self
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ChatList")
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        //fetchRequest.fetchBatchSize = 20
        
        // Initialize Fetched Results Controller
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
            self.messageListTableView.reloadData()
            
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }

    }
    
    func showBlockRecruiterAlert() {
        let alert = UIAlertController(title: "", message: "This Blocked recruiter will no longer be able to send you message", preferredStyle: .actionSheet)
        let blockAction = UIAlertAction(title: "Block", style: .destructive) { (action:UIAlertAction) in
            self.blockRecruiter()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            
        }
        alert.addAction(blockAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }    
}
