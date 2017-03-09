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
    var placeHolderEmptyJobsView:PlaceHolderJobsView?

    let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    let todaysDate = Date.getTodaysDateMMDDYYYY()
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(redirectToChat), name: .chatRedirect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshBlockUnblockList), name: .refreshBlockUnblockList, object: nil)

        setup()
        SocketManager.sharedInstance.initServer()
        self.getChatListAPI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshMessageList), name: .refreshMessageList, object: nil)
        SocketManager.sharedInstance.removeAllCompletionHandlers()
        if let selectedIndex = self.messageListTableView.indexPathForSelectedRow {
            self.messageListTableView.deselectRow(at: selectedIndex, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .refreshMessageList, object: nil)
        //NotificationCenter.default.removeObserver(self)
    }
    
    func setup() {
        
        dateFormatter.dateFormat = Date.dateFormatMMDDYYYY()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteFetchController), name: .deleteFetchController, object: nil)
        
        self.navigationItem.title = "MESSAGES"
        self.messageListTableView.dataSource = nil
        self.messageListTableView.tableFooterView = UIView()
        self.messageListTableView.register(UINib(nibName: "MessageListTableCell", bundle: nil), forCellReuseIdentifier: "MessageListTableCell")
        
        placeHolderEmptyJobsView = PlaceHolderJobsView.loadPlaceHolderJobsView()
        placeHolderEmptyJobsView?.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        placeHolderEmptyJobsView?.center = self.view.center
        placeHolderEmptyJobsView?.backgroundColor = UIColor.clear
        var frame = placeHolderEmptyJobsView!.frame
        frame = CGRect(x: frame.origin.x, y: frame.origin.y - 44, width: frame.size.width, height: frame.size.height)
        placeHolderEmptyJobsView?.frame = frame
        self.view.addSubview(placeHolderEmptyJobsView!)
        placeHolderEmptyJobsView?.placeholderImageView.image = UIImage(named: "chatListPlaceHolder")
        placeHolderEmptyJobsView?.placeHolderMessageLabel.text = "No message in your chats yet."

        self.view.layoutIfNeeded()
    }
    
    func getMessageList() {
        self.messageListTableView.dataSource = self
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ChatList")
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        //fetchRequest.fetchBatchSize = 20
        
        // Initialize Fetched Results Controller
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
            self.messageListTableView.reloadData()
            if let sections = self.fetchedResultsController.sections {
                if sections.count > 0 {
                    if sections[0].numberOfObjects > 0 {
                        self.placeHolderEmptyJobsView?.isHidden = true
                    }
                }
            }
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }

    }
    
    func showBlockRecruiterAlert(chatList:ChatList) {
        let alert = UIAlertController(title: "", message: "This Blocked recruiter will no longer be able to send you message", preferredStyle: .actionSheet)
        let blockAction = UIAlertAction(title: "Block", style: .destructive) { (action:UIAlertAction) in
            //SocketManager.sharedInstance.handleBlockUnblock(chatList: chatList, blockStatus: "1")
            self.blockRecruiter(chatList: chatList)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            
        }
        alert.addAction(blockAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteFetchController() {
        fetchedResultsController.delegate = nil
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil)
//        try self.fetchedResultsController.performFetch(nil)
//        self.fetchedResultsController.fetchRequest.predicate =
//            [NSPredicate  predicateWithValue:NO];
    }
    
    func refreshMessageList() {
        if fetchedResultsController != nil {
            fetchedResultsController.delegate = nil
            fetchedResultsController = nil
            self.getChatListAPI()
        }
    }
    
    func openChatPage(chatList:ChatList) {
        let chatVC = UIStoryboard.messagesStoryBoard().instantiateViewController(type: DMChatVC.self)!
        chatVC.chatList = chatList
        chatVC.hidesBottomBarWhenPushed = true
        chatVC.delegate = self
        if DatabaseManager.getCountForChats(recruiterId: chatList.recruiterId!) == 0 {
            chatVC.shouldFetchFromBeginning = true
        }
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    func redirectToChat(notification:Notification) {
        let recruiterId = notification.userInfo?["recruiterId"] as! String
        if let chatList = DatabaseManager.chatListExists(recruiterId: recruiterId) {
            openChatPage(chatList: chatList)
        } else {
            //Recruiter Doesn't exists in core data
        }
    }
    
    func refreshBlockUnblockList(notification:Notification) {
        print(notification.userInfo)
        self.makeToast(toastString: "Recruiter Blocked")
    }
}

extension DMMessagesVC:ChatTapNotificationDelegate {
    
    func notificationTapped(recruiterId: String) {
        _ = self.navigationController?.popToRootViewController(animated: false)
        if let chatList = DatabaseManager.chatListExists(recruiterId: recruiterId) {
           openChatPage(chatList: chatList)
        } else {
            //Recruiter Doesn't exists in core data
        }
    }
}
