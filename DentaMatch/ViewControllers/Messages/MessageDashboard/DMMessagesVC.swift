//
//  DMMessagesVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 22/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import CoreData
import UIKit

class DMMessagesVC: DMBaseVC {
    @IBOutlet var messageListTableView: UITableView!
    var placeHolderEmptyJobsView: PlaceHolderJobsView?

    let context = ((UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext)!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!

    let todaysDate = Date.getTodaysDateMMDDYYYY()

    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(redirectToChat), name: .chatRedirect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshBlockList), name: .refreshBlockList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideMessagePlaceholder), name: .hideMessagePlaceholder, object: nil)

        setup()
        SocketManager.sharedInstance.initServer()
        getChatListAPI()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshMessageList), name: .refreshMessageList, object: nil)
        SocketManager.sharedInstance.removeAllCompletionHandlers()
        if let selectedIndex = self.messageListTableView.indexPathForSelectedRow {
            messageListTableView.deselectRow(at: selectedIndex, animated: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .refreshMessageList, object: nil)
        // NotificationCenter.default.removeObserver(self)
    }

    func setup() {
        dateFormatter.dateFormat = Date.dateFormatMMDDYYYY()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        NotificationCenter.default.addObserver(self, selector: #selector(deleteFetchController), name: .deleteFetchController, object: nil)

        navigationItem.title = "MESSAGES"
        messageListTableView.dataSource = nil
        messageListTableView.tableFooterView = UIView()
        messageListTableView.register(UINib(nibName: "MessageListTableCell", bundle: nil), forCellReuseIdentifier: "MessageListTableCell")

        placeHolderEmptyJobsView = PlaceHolderJobsView.loadPlaceHolderJobsView()
        placeHolderEmptyJobsView?.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        placeHolderEmptyJobsView?.center = view.center
        placeHolderEmptyJobsView?.backgroundColor = UIColor.clear
        var frame = placeHolderEmptyJobsView!.frame
        frame = CGRect(x: frame.origin.x, y: frame.origin.y - 44, width: frame.size.width, height: frame.size.height)
        placeHolderEmptyJobsView?.frame = frame
        view.addSubview(placeHolderEmptyJobsView!)
        placeHolderEmptyJobsView?.placeholderImageView.image = UIImage(named: "chatListPlaceHolder")
        placeHolderEmptyJobsView?.placeHolderMessageLabel.text = "No message in your chats yet."

        view.layoutIfNeeded()
    }

    func getMessageList() {
        messageListTableView.dataSource = self
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ChatList")

        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        // fetchRequest.fetchBatchSize = 20

        // Initialize Fetched Results Controller
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
            messageListTableView.reloadData()
            if let sections = self.fetchedResultsController.sections {
                if sections.count > 0 {
                    if sections[0].numberOfObjects > 0 {
                        placeHolderEmptyJobsView?.isHidden = true
                    }
                }
            }
        } catch {
            // let fetchError = error as NSError
            // debugPrint("\(fetchError), \(fetchError.userInfo)")
        }
    }

    func showBlockRecruiterAlert(chatList: ChatList) {
        let alert = UIAlertController(title: "", message: "This Recruiter is BLOCKED and will no longer be able to see your profile or send you messages", preferredStyle: .actionSheet)
        let blockAction = UIAlertAction(title: "Block", style: .destructive) { (_: UIAlertAction) in
            SocketManager.sharedInstance.handleBlockUnblock(chatList: chatList, blockStatus: "1")
            // self.blockRecruiter(chatList: chatList)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_: UIAlertAction) in
            // debugPrint("Cancel Action")
        }
        alert.addAction(blockAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    @objc func deleteFetchController() {
        fetchedResultsController.delegate = nil
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil)
    }

    @objc func refreshMessageList() {
        if fetchedResultsController != nil {
            fetchedResultsController.delegate = nil
            fetchedResultsController = nil
            getChatListAPI()
        }
    }

    func openChatPage(chatList: ChatList) {
        let chatVC = UIStoryboard.messagesStoryBoard().instantiateViewController(type: DMChatVC.self)!
        chatVC.chatList = chatList
        chatVC.hidesBottomBarWhenPushed = true
        chatVC.delegate = self
        if DatabaseManager.getCountForChats(recruiterId: chatList.recruiterId!) == 0 {
            chatVC.shouldFetchFromBeginning = true
        }
        navigationController?.pushViewController(chatVC, animated: true)
    }

    @objc func redirectToChat(notification: Notification) {
        guard let recruiterId = notification.userInfo?["recruiterId"] as? String else { return }
        if let chatList = DatabaseManager.chatListExists(recruiterId: recruiterId) {
            openChatPage(chatList: chatList)
        } else {
            LogManager.logDebug("Recruiter Doesn't exists in core data")
        }
    }

    @objc func refreshBlockList(notification _: Notification) {
        // print(notification.userInfo)
        makeToast(toastString: "Recruiter Blocked")
    }

    @objc func hideMessagePlaceholder() {
        placeHolderEmptyJobsView?.isHidden = true
    }
}

extension DMMessagesVC: ChatTapNotificationDelegate {
    func notificationTapped(recruiterId: String) {
        _ = navigationController?.popToRootViewController(animated: false)
        if let chatList = DatabaseManager.chatListExists(recruiterId: recruiterId) {
            openChatPage(chatList: chatList)
        } else {
            // Recruiter Doesn't exists in core data
        }
    }
}
