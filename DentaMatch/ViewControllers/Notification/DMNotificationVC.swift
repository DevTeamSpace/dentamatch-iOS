//
//  DMNotificationVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 08/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
enum UserNotificationType:Int {
    case acceptJob = 1
    case hired
    case jobCancellation
    case deleteJob
    case verifyDocuments
    case completeProfile
    case chatMessgae
    case other
    case InviteJob
}
class DMNotificationVC: DMBaseVC {
    @IBOutlet weak var notificationTableView: UITableView!
    var pullToRefreshNotifications = UIRefreshControl()
    var loadingMoreNotifications = false
    var pageNumber = 1
    var totalNotificationOnServer = 0
    var placeHolderEmptyJobsView:PlaceHolderJobsView?

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
        placeHolderEmptyJobsView?.center = self.view.center
        placeHolderEmptyJobsView?.backgroundColor = UIColor.clear
        placeHolderEmptyJobsView?.placeHolderMessageLabel.numberOfLines = 2
        placeHolderEmptyJobsView?.placeHolderMessageLabel.text = Constants.AlertMessage.noNotification
        self.view.addSubview(placeHolderEmptyJobsView!)
        placeHolderEmptyJobsView?.isHidden = false
        self.placeHolderEmptyJobsView?.layoutIfNeeded()
        self.view.layoutIfNeeded()

        
        self.title = Constants.ScreenTitleNames.notification
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftBarButtonItem = self.backBarButton()

        self.notificationTableView.separatorStyle = .none
        self.notificationTableView.backgroundColor = UIColor.clear
        self.notificationTableView.estimatedRowHeight = 76
        self.notificationTableView.register(UINib(nibName: "HiredJobNotificationTableCell", bundle: nil), forCellReuseIdentifier: "HiredJobNotificationTableCell")
        self.notificationTableView.register(UINib(nibName: "CommonTextNotificationTableCell", bundle: nil), forCellReuseIdentifier: "CommonTextNotificationTableCell")
        self.notificationTableView.register(UINib(nibName: "NotificationJobTypeTableCell", bundle: nil), forCellReuseIdentifier: "NotificationJobTypeTableCell")
        self.notificationTableView.register(UINib(nibName: "InviteJobNotificationTableCell", bundle: nil), forCellReuseIdentifier: "InviteJobNotificationTableCell")

        pullToRefreshNotifications.addTarget(self, action: #selector(pullToRefreshForNotification), for: .valueChanged)
        self.notificationTableView.addSubview(pullToRefreshNotifications)

        self.pageNumber = 1
        self.getNotificationList { (isSucess, error) in
            if isSucess! {
                self.notificationTableView.reloadData()
            }else{
                
            }
        }
    }
    
    func pullToRefreshForNotification() {
        self.pageNumber = 1
        self.getNotificationList { (isSucess, error) in
            if isSucess! {
                self.notificationTableView.reloadData()
            }else{
                
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
