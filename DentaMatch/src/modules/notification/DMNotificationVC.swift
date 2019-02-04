import UIKit
enum UserNotificationType: Int {
    case acceptJob = 1
    case hired
    case jobCancellation
    case deleteJob
    case verifyDocuments
    case completeProfile
    case chatMessgae
    case other
    case InviteJob
    case rejectJob = 14
    case licenseAcceptReject = 15
}

class DMNotificationVC: DMBaseVC {
    @IBOutlet var notificationTableView: UITableView!
    var pullToRefreshNotifications = UIRefreshControl()
    var placeHolderEmptyJobsView: PlaceHolderJobsView?
    
    var viewOutput: DMNotificationsViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setup() {
        placeHolderEmptyJobsView = PlaceHolderJobsView.loadPlaceHolderJobsView()
        placeHolderEmptyJobsView?.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        placeHolderEmptyJobsView?.center = view.center
        placeHolderEmptyJobsView?.backgroundColor = UIColor.clear
        placeHolderEmptyJobsView?.placeHolderMessageLabel.numberOfLines = 2
        placeHolderEmptyJobsView?.placeHolderMessageLabel.text = Constants.AlertMessage.noNotification
        placeHolderEmptyJobsView?.placeholderImageView.image = UIImage(named: "notificationPlaceholder")
        view.addSubview(placeHolderEmptyJobsView!)
        placeHolderEmptyJobsView?.isHidden = false
        placeHolderEmptyJobsView?.layoutIfNeeded()
        view.layoutIfNeeded()

        title = Constants.ScreenTitleNames.notification
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.leftBarButtonItem = backBarButton()

        notificationTableView.separatorStyle = .none
        notificationTableView.backgroundColor = UIColor.clear
        notificationTableView.estimatedRowHeight = 76
        notificationTableView.register(UINib(nibName: "HiredJobNotificationTableCell", bundle: nil), forCellReuseIdentifier: "HiredJobNotificationTableCell")
        notificationTableView.register(UINib(nibName: "CommonTextNotificationTableCell", bundle: nil), forCellReuseIdentifier: "CommonTextNotificationTableCell")
        notificationTableView.register(UINib(nibName: "NotificationJobTypeTableCell", bundle: nil), forCellReuseIdentifier: "NotificationJobTypeTableCell")
        notificationTableView.register(UINib(nibName: "InviteJobNotificationTableCell", bundle: nil), forCellReuseIdentifier: "InviteJobNotificationTableCell")

        pullToRefreshNotifications.addTarget(self, action: #selector(pullToRefreshForNotification), for: .valueChanged)
        notificationTableView.addSubview(pullToRefreshNotifications)

        showLoading()
        viewOutput?.refreshData()
    }

    @objc func pullToRefreshForNotification() {
        viewOutput?.refreshData()
    }

    
}

extension DMNotificationVC: DMNotificationsViewInput {
    
    func reloadData() {
        pullToRefreshNotifications.endRefreshing()
        notificationTableView.reloadData()
        
        placeHolderEmptyJobsView?.isHidden = viewOutput?.notificationList.count != 0
        notificationTableView.tableFooterView = nil
    }
    
    func addLoadingFooter() {
        
        let footer = Bundle.main.loadNibNamed("LoadMoreView", owner: nil, options: nil)?[0] as? LoadMoreView
        footer!.frame = CGRect(x: 0, y: 0, width: notificationTableView.frame.size.width, height: 44)
        footer?.layoutIfNeeded()
        footer?.activityIndicator.startAnimating()
        
        notificationTableView.tableFooterView = footer
    }
}
