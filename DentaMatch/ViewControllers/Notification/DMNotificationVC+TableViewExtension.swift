//
//  DMNotificationVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 08/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMNotificationVC : UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let notificationObj = notificationList[indexPath.row]
        let notificationType = UserNotificationType(rawValue: notificationObj.notificationType!)!

        switch notificationType {
        case .acceptJob,.jobCancellation,.deleteJob :
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationJobTypeTableCell") as? NotificationJobTypeTableCell
            cell?.configureNotificationJobTypeTableCell(userNotificationObj: notificationObj)
            return cell!
            
        case .hired:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HiredJobNotificationTableCell") as? HiredJobNotificationTableCell
            cell?.configureHiredJobNotificationTableCell(userNotificationObj: notificationObj)
            return cell!
        case .verifyDocuments,.completeProfile,.chatMessgae,.other,.InviteJob:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextNotificationTableCell") as? CommonTextNotificationTableCell
            cell?.configureCommonTextNotificationTableCell(userNotificationObj: notificationObj)
            return cell!
        }
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if notificationList.count > 9 {
            if indexPath.row == notificationList.count - 2 {
                loadMoreNotification()
            }
        }
    }
    func loadMoreNotification() {
        
        if loadingMoreNotifications == true {
            return
        }
        else{
            if self.totalNotificationOnServer > self.notificationList.count {
                setupLoadingMoreOnTable(tableView: self.notificationTableView)
                loadingMoreNotifications = true
                self.getNotificationList { (isSucess, error) in
                    if isSucess! {
                        self.loadingMoreNotifications = false

                        self.notificationTableView.reloadData()
                    }else{
                        self.loadingMoreNotifications = false

                    }
                }

            }
        }

        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notifiObj = self.notificationList[indexPath.row]
        if notifiObj.seen == 1 {
            // need to implement
            self.redirectToDetail(notiObj: notifiObj)
        }else {
            self.readNotificationToServer(notificationObj: notifiObj) { (response, error) in
                if response![Constants.ServerKey.status].boolValue {
                    notifiObj.seen = 1
                    self.notificationTableView.reloadData()
                    self.redirectToDetail(notiObj: notifiObj)
                }
            }
        }
       
        
    }
    
    
    
    
    func redirectToDetail(notiObj:UserNotification) {
        let notificationType = UserNotificationType(rawValue: notiObj.notificationType!)!
        
        switch notificationType {
        case .acceptJob:
        //open job detail
            goTOJobDetail(jobObj: notiObj.jobdetail!)
        case .chatMessgae: break
        //No need any action
        case .completeProfile: break
        //open profile
            self.tabBarController?.selectedIndex = 4
        case .deleteJob: break
        //No need any action
        case .hired:
        //open job detail
        goTOJobDetail(jobObj: notiObj.jobdetail!)
        case .jobCancellation:
        //open job detail
        goTOJobDetail(jobObj: notiObj.jobdetail!)
        case .verifyDocuments: break
        //open edit profile
        self.tabBarController?.selectedIndex = 4

        case .other,.InviteJob: break
            //No need any action
            
            
        }
    }
    
    func goTOJobDetail(jobObj:Job) {
        let jobDetailVC = UIStoryboard.jobSearchStoryBoard().instantiateViewController(type: DMJobDetailVC.self)!
        jobDetailVC.fromNotificationVC = false
        jobDetailVC.job = jobObj
        jobDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(jobDetailVC, animated: true)

    }
    
    
    
    
    
    func setupLoadingMoreOnTable(tableView:UITableView) {
        let footer = Bundle.main.loadNibNamed("LoadMoreView", owner: nil, options: nil)?[0] as? LoadMoreView
        footer!.frame = CGRect(x:0, y:0, width:tableView.frame.size.width,height:44)
        footer?.layoutIfNeeded();
        footer?.activityIndicator.startAnimating();
        tableView.tableFooterView = footer;
    }

}
