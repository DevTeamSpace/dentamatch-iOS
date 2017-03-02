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
            
        case .InviteJob:
            return configureInviteCell(notification: notificationObj, tableView: tableView)
            
        case .verifyDocuments,.completeProfile,.chatMessgae,.other:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextNotificationTableCell") as? CommonTextNotificationTableCell
            cell?.configureCommonTextNotificationTableCell(userNotificationObj: notificationObj)
            return cell!
        }
        
    }
    
    func configureInviteCell(notification:UserNotification,tableView:UITableView ) -> UITableViewCell{
        
        if notification.seen == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InviteJobNotificationTableCell") as? InviteJobNotificationTableCell
            cell?.configureInviteJobNotificationTableCell(userNotificationObj: notification)
            cell?.btnAccept.addTarget(self, action: #selector(btnAcceptButtonClicked(_:)), for: .touchUpInside)
            cell?.btnDelete.addTarget(self, action: #selector(btnRejectButtonClicked(_:)), for: .touchUpInside)
            return cell!
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HiredJobNotificationTableCell") as? HiredJobNotificationTableCell
            cell?.configureHiredJobNotificationTableCell(userNotificationObj: notification)
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
            let deleteAction = UITableViewRowAction(style: .normal, title: "Delete", handler: { (action:UITableViewRowAction, indexPath:IndexPath) in
                let notification = self.notificationList[indexPath.row]
                self.deleteNotification(notificationObj: notification, completionHandler: { (isSucess, error) in
                    if isSucess! {
                        self.notificationList.remove(at: indexPath.row)
                        self.notificationTableView.reloadData()
                    }
                })
                
            })
            deleteAction.backgroundColor = Constants.Color.cancelJobDeleteColor
            return [ deleteAction]
            
        
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
    
    func btnAcceptButtonClicked(_ sender: Any) {
        let tag = (sender as AnyObject).tag
        let notifiObj = self.notificationList[tag!]

        self.inviteActionSendToServer(notificationObj: notifiObj, actionType: 1) { (response, error) in
            if response![Constants.ServerKey.status].boolValue {
                notifiObj.seen = 1
                self.notificationTableView.reloadData()
            }
        }
    }
    func btnRejectButtonClicked(_ sender: Any) {
        let tag = (sender as AnyObject).tag
        let notifiObj = self.notificationList[tag!]
        self.inviteActionSendToServer(notificationObj: notifiObj, actionType: 0) { (response, error) in
            if response![Constants.ServerKey.status].boolValue {
                notifiObj.seen = 1
                self.notificationTableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let notifiObj = self.notificationList[indexPath.row]
        if notifiObj.seen == 1 {
            // need to implement
            self.redirectToDetail(notiObj: notifiObj)
        }else {
            if notifiObj.notificationType == UserNotificationType.InviteJob.rawValue {
                //in case of invite we need to no need to call service
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
    }
    
    
    
    
    func redirectToDetail(notiObj:UserNotification) {
        let notificationType = UserNotificationType(rawValue: notiObj.notificationType!)!
        
        switch notificationType {
        case .acceptJob:
        //open job detail
            goToJobDetail(jobObj: notiObj.jobdetail!)
        case .chatMessgae: break
        //No need any action
        case .completeProfile: break
        //open profile
            self.tabBarController?.selectedIndex = 4
        case .deleteJob: break
        //No need any action
        case .hired,.InviteJob:
        //open job detail
        goToJobDetail(jobObj: notiObj.jobdetail!)
        case .jobCancellation:
        //open job detail
        goToJobDetail(jobObj: notiObj.jobdetail!)
        case .verifyDocuments: break
        //open edit profile
        self.tabBarController?.selectedIndex = 4

        case .other: break
            //No need any action
        }
    }
    
    func goToJobDetail(jobObj:Job) {
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
