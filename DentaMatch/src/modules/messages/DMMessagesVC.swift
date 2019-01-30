import RealmSwift
import UIKit

class DMMessagesVC: DMBaseVC {
    @IBOutlet var messageListTableView: UITableView!
    var placeHolderEmptyJobsView: PlaceHolderJobsView?
    var refreshControl: UIRefreshControl!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let todaysDate = Date.getTodaysDateMMDDYYYY()

    let dateFormatter = DateFormatter()
 
    var chatListArray = [ChatListModel]()
    weak var moduleOutput: DMMessagesModuleOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(redirectToChat), name: .chatRedirect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshBlockList), name: .refreshBlockList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideMessagePlaceholder), name: .hideMessagePlaceholder, object: nil)

        setup()
        SocketIOManager.sharedInstance.initServer()
        getChatListAPI()
        // Do any additional setup after loading the view.
         NotificationCenter.default.addObserver(self, selector: #selector(refreshMessageList), name: .refreshMessageList, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        SocketIOManager.sharedInstance.removeAllCompletionHandlers()
        if let selectedIndex = self.messageListTableView.indexPathForSelectedRow {
            messageListTableView.deselectRow(at: selectedIndex, animated: true)
        }
        //self.setNotificationLabelText(count: AppDelegate.delegate().badgeCount())

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
        // NotificationCenter.default.removeObserver(self)
    }

    func setup() {
        dateFormatter.dateFormat = Date.dateFormatMMDDYYYY()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

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
        messageListTableView.dataSource = nil
        messageListTableView.delegate = nil
        messageListTableView.tableFooterView = UIView()
        messageListTableView.register(UINib(nibName: "MessageListTableCell", bundle: nil), forCellReuseIdentifier: "MessageListTableCell")
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refreshMessageList), for: .valueChanged)
        messageListTableView.addSubview(refreshControl)
    }

    func getMessageList() {
        messageListTableView.dataSource = self
        messageListTableView.delegate = self
        
        let realm = try! Realm()
        let chatLists = realm.objects(ChatListModel.self).sorted(by: { $0.timeStamp > $1.timeStamp })
        
        chatListArray.removeAll()
        chatListArray.append(contentsOf: chatLists)
        
        placeHolderEmptyJobsView?.isHidden = chatListArray.count != 0

        messageListTableView.reloadData()
    }
    
    func showChatDeleteAlert(chatList: ChatListModel) {
        let alert = UIAlertController(title: "Alert!", message: "The chat will be deleted permanently.\nAre you sure you want to delete this chat? ", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_: UIAlertAction) in
            // debugPrint("Cancel Action")
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_: UIAlertAction) in
            self.deleteChat(chatList: chatList)
        }
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    func showBlockRecruiterAlert(chatList: ChatListModel) {
        let alert = UIAlertController(title: "", message: "This Recruiter is BLOCKED and will no longer be able to see your profile or send you messages", preferredStyle: .actionSheet)
        let blockAction = UIAlertAction(title: "Block", style: .destructive) { (_: UIAlertAction) in
            SocketIOManager.sharedInstance.handleBlockUnblock(chatList: chatList, blockStatus: "1")
            // self.blockRecruiter(chatList: chatList)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_: UIAlertAction) in
            // debugPrint("Cancel Action")
        }
        alert.addAction(blockAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func refreshMessageList() {
        getChatListAPI(isLoaderHidden: true)
    }

    func openChatPage(chatList: ChatListModel) {
        
        moduleOutput?.showChat(chatList: chatList,
                               fetchFromBegin: DatabaseManager.getCountForChats(recruiterId: chatList.recruiterId) == 0,
                               delegate: self)
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
    
    /*func customLeftBarButton() -> UIBarButtonItem {
        notificationLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 15, height: 15))
        notificationLabel?.backgroundColor = UIColor.red
        notificationLabel?.layer.cornerRadius = (notificationLabel?.bounds.size.height)! / 2
        notificationLabel?.font = UIFont.fontRegular(fontSize: 10)
        notificationLabel?.textAlignment = .center
        notificationLabel?.textColor = UIColor.white
        notificationLabel?.clipsToBounds = true
        notificationLabel?.text = ""
        notificationLabel?.isHidden = true
        let customButton = UIButton(type: .system)
        customButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        customButton.titleLabel?.font = UIFont.designFont(fontSize: 18)
        customButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        customButton.setTitle(Constants.DesignFont.notification, for: .normal)
        customButton.addTarget(self, action: #selector(actionLeftNavigationItem), for: .touchUpInside)
        customButton.addSubview(notificationLabel!)
        let barButton = UIBarButtonItem(customView: customButton)
        return barButton
    }
    
    @objc override func actionLeftNavigationItem() {
        // will implement
        let notification = UIStoryboard.notificationStoryBoard().instantiateViewController(type: DMNotificationVC.self)!
        notification.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(notification, animated: true)
    }
    
    func setNotificationLabelText(count: Int) {
        if count != 0 {
            notificationLabel?.text = "\(count)"
            notificationLabel?.isHidden = false
            notificationLabel?.adjustsFontSizeToFitWidth = true
            
        } else {
            notificationLabel?.isHidden = true
        }
    }*/
    
    deinit {
         NotificationCenter.default.removeObserver(self, name: .refreshMessageList, object: nil)
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
