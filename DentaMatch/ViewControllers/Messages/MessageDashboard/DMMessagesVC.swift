//
//  DMMessagesVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 22/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMMessagesVC: DMBaseVC {

    @IBOutlet weak var messageListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
        self.messageListTableView.register(UINib(nibName: "MessageListTableCell", bundle: nil), forCellReuseIdentifier: "MessageListTableCell")
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
