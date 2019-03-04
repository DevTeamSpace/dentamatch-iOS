import UIKit

class DMMessagesVC: DMBaseVC {
    @IBOutlet var messageListTableView: UITableView!
    var placeHolderEmptyJobsView: PlaceHolderJobsView?
    var refreshControl: UIRefreshControl!
    
    var viewOutput: DMMessagesViewOutput?
    
    let todaysDate = Date.getTodaysDateMMDDYYYY()
    let dateFormatter = DateFormatter()
 
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateFormat = Date.dateFormatMMDDYYYY()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        setup()
        
        viewOutput?.didLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        viewOutput?.willAppear()
    }
    
    func setup() {
        
        navigationItem.title = "MESSAGES"
        
        self.configureTableView()
        
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
    
    private func configureTableView() {
        messageListTableView.dataSource = self
        messageListTableView.delegate = self
        messageListTableView.tableFooterView = UIView()
        messageListTableView.register(UINib(nibName: "MessageListTableCell", bundle: nil), forCellReuseIdentifier: "MessageListTableCell")
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        messageListTableView.addSubview(refreshControl)
    }
    
    @objc func refreshData() {
        viewOutput?.refreshData()
    }
    
    func showChatDeleteAlert(chatList: ChatListModel) {
        
        let alert = UIAlertController(title: "Alert!", message: "The chat will be deleted permanently.\nAre you sure you want to delete this chat? ", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (_: UIAlertAction) in
            self?.viewOutput?.deleteChat(recruiterId: chatList.recruiterId)
        }
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

    func showBlockRecruiterAlert(chatList: ChatListModel) {
        
        let alert = UIAlertController(title: "", message: "This Recruiter is BLOCKED and will no longer be able to see your profile or send you messages", preferredStyle: .actionSheet)
        
        let blockAction = UIAlertAction(title: "Block", style: .destructive) { [weak self] (_: UIAlertAction) in
            self?.viewOutput?.blockUnblockRecruiter(id: chatList.recruiterId, isBlocked: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(blockAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func openChatPage(chatList: ChatListModel) {
        guard SocketIOManager.sharedInstance.isConnected else {
            show(toastMessage: "Chat anavailable")
            return
        }
        
        viewOutput?.openChat(chatList: chatList,
                             delegate: self)
    }

    @objc func refreshBlockList(notification _: Notification) {
        makeToast(toastString: "Recruiter Blocked")
    }
}

extension DMMessagesVC: DMMessagesViewInput {
    
    func reloadData() {
        refreshControl.endRefreshing()
        messageListTableView.reloadData()
    }
    
    func configureEmptyView(isHidden: Bool) {
        placeHolderEmptyJobsView?.isHidden = isHidden
    }
}

extension DMMessagesVC: ChatTapNotificationDelegate {
    
    func notificationTapped(recruiterId: String) {
        _ = navigationController?.popToRootViewController(animated: false)
        
        if let chatList = DatabaseManager.chatListExists(recruiterId: recruiterId) {
            openChatPage(chatList: chatList)
        }
    }
}
