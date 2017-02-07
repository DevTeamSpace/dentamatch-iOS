//
//  DMChatVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 06/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import CoreData

class DMChatVC: DMBaseVC {
    @IBOutlet weak var chatTableView: UITableView!

    var array = [
        "asdhg sadjhg sadjh asdgf sadghfsad ghfsad gfasd asdgfghasdfhgasdfhgasdfh adsfhgas",
        "Yes, I’m comfortable working part time",
        "Hi",
        "asdhg sagdhsdg trhr wgh asd jha  atsudfjasdjasdf sadjg sadj asdgfsadgasd ghfasd hgasdf hgasd asfghd asdghf asdfhadgs"
    ]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        SocketManager.sharedInstance.initServer()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        SocketManager.sharedInstance.getChatMessage { (object:[String : AnyObject]) in
            print(object)
        }
    }
    
    func setup() {
        self.chatTableView.register(UINib(nibName: "MessageSenderTableCell", bundle: nil), forCellReuseIdentifier: "MessageSenderTableCell")
        self.chatTableView.register(UINib(nibName: "MessageReceiverTableCell", bundle: nil), forCellReuseIdentifier: "MessageReceiverTableCell")
    }
    
    @IBAction func sendMessageButtonPressed(_ sender: Any) {
        //Send Message
        SocketManager.sharedInstance.sendTextMessage(message: "")
    }

}
