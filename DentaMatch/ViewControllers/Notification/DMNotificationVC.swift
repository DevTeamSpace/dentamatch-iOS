//
//  DMNotificationVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 08/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

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
    var loadingMoreNotifications = false
    var pageNumber = 1
    var totalNotificationOnServer = 0
    var placeHolderEmptyJobsView: PlaceHolderJobsView?

    var notificationList = [UserNotification]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        // Do any additional setup after loading the view.
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

        pageNumber = 1
        getNotificationList { isSucess, _ in
            if isSucess! {
                self.notificationTableView.reloadData()
            } else {
            }
        }
    }

    @objc func pullToRefreshForNotification() {
        pageNumber = 1
        getNotificationList { isSucess, _ in
            if isSucess! {
                self.notificationTableView.reloadData()
            } else {
            }
        }
        pullToRefreshNotifications.endRefreshing()
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
