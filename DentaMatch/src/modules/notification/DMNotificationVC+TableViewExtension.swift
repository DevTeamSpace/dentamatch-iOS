//
//  DMNotificationVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 08/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMNotificationVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return notificationList.count
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notificationObj = notificationList[indexPath.row]
        let notificationType = UserNotificationType(rawValue: notificationObj.notificationType!)!

        switch notificationType {
        case .acceptJob, .jobCancellation, .deleteJob, .rejectJob, .licenseAcceptReject:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationJobTypeTableCell") as? NotificationJobTypeTableCell
            cell?.configureNotificationJobTypeTableCell(userNotificationObj: notificationObj)
            return cell!

        case .hired:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HiredJobNotificationTableCell") as? HiredJobNotificationTableCell
            cell?.configureHiredJobNotificationTableCell(userNotificationObj: notificationObj)
            return cell!

        case .InviteJob:
            return configureInviteCell(indexPath: indexPath, notification: notificationObj, tableView: tableView)

        case .verifyDocuments, .completeProfile, .chatMessgae, .other:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextNotificationTableCell") as? CommonTextNotificationTableCell
            cell?.configureCommonTextNotificationTableCell(userNotificationObj: notificationObj)
            cell?.disclosureIndicatorView.isHidden = true
            return cell!
        }
    }

    func configureInviteCell(indexPath: IndexPath, notification: UserNotification, tableView: UITableView) -> UITableViewCell {
        if notification.seen == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InviteJobNotificationTableCell") as? InviteJobNotificationTableCell
            cell?.configureInviteJobNotificationTableCell(userNotificationObj: notification)
            cell?.btnAccept.tag = indexPath.row
            cell?.btnAccept.addTarget(self, action: #selector(btnAcceptButtonClicked(_:)), for: .touchUpInside)
            cell?.btnDelete.addTarget(self, action: #selector(btnRejectButtonClicked(_:)), for: .touchUpInside)
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HiredJobNotificationTableCell") as? HiredJobNotificationTableCell
            cell?.configureHiredJobNotificationTableCell(userNotificationObj: notification)
            return cell!
        }
    }

    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        if notificationList.count > 9 {
            if indexPath.row == notificationList.count - 2 {
                loadMoreNotification()
            }
        }
    }

    func tableView(_: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete", handler: { (_: UITableViewRowAction, indexPath: IndexPath) in
            let notification = self.notificationList[indexPath.row]

            self.alertMessage(title: "Confirm Deletion", message: "Are you sure you want to delete this notification?", leftButtonText: "Yes", rightButtonText: "No", completionHandler: { (isLeft: Bool) in
                if isLeft {
                    self.deleteNotification(notificationObj: notification, completionHandler: { isSucess, _ in
                        if isSucess! {
                            self.notificationList.remove(at: indexPath.row)
                            if notification.seen == nil || notification.seen == 0 {
                                NotificationCenter.default.post(name: .decreaseBadgeCount, object: nil, userInfo: nil)
                            }
                            DispatchQueue.main.async {
                                self.notificationTableView.reloadData()
                            }
                        }
                    })
                }
            })
        })
        deleteAction.backgroundColor = Constants.Color.cancelJobDeleteColor
        return [deleteAction]
    }

    func loadMoreNotification() {
        if loadingMoreNotifications == true {
            return
        } else {
            if totalNotificationOnServer > notificationList.count {
                setupLoadingMoreOnTable(tableView: notificationTableView)
                loadingMoreNotifications = true
                getNotificationList { isSucess, _ in
                    if isSucess! {
                        self.loadingMoreNotifications = false

                        self.notificationTableView.reloadData()
                    } else {
                        self.loadingMoreNotifications = false
                    }
                }
            }
        }
    }

    @objc func btnAcceptButtonClicked(_ sender: Any) {
        let tag = (sender as AnyObject).tag
        let notifiObj = notificationList[tag!]

        inviteActionSendToServer(notificationObj: notifiObj, actionType: 1) { response, error in
            if error != nil {
                return
            }
            // debugPrint(response!)
            if response![Constants.ServerKey.status].boolValue {
                notifiObj.seen = 1
                NotificationCenter.default.post(name: .decreaseBadgeCount, object: nil, userInfo: nil)
                self.notificationTableView.reloadData()
                NotificationCenter.default.post(name: .refreshMessageList, object: nil)
            } else {
                if response![Constants.ServerKey.statusCode].intValue == 201 {
                    self.alertMessage(title: "Change Availability", message: response![Constants.ServerKey.message].stringValue, buttonText: "Ok", completionHandler: {
                    })
                } else {
                    self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                }
            }
        }
    }

    @objc func btnRejectButtonClicked(_ sender: Any) {
        let tag = (sender as AnyObject).tag
        let notifiObj = notificationList[tag!]
        alertMessage(title: "Confirm Rejection", message: "Are you sure you want to reject this job invitation?", leftButtonText: "Yes", rightButtonText: "No") { (isLeft: Bool) in
            if isLeft {
                self.inviteActionSendToServer(notificationObj: notifiObj, actionType: 0) { response, _ in
                    if response![Constants.ServerKey.status].boolValue {
                        notifiObj.seen = 1
                        NotificationCenter.default.post(name: .decreaseBadgeCount, object: nil, userInfo: nil)
                        DispatchQueue.main.async {
                            self.notificationTableView.reloadData()
                        }
                    }else {
                        if response![Constants.ServerKey.statusCode].intValue == 201 {
                            self.alertMessage(title: "Change Availability", message: response![Constants.ServerKey.message].stringValue, buttonText: "Ok", completionHandler: {
                            })
                        } else {
                            self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                        }
                    }
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let notifiObj = notificationList[indexPath.row]
        if notifiObj.seen == 1 {
            // need to implement
            redirectToDetail(notiObj: notifiObj)
        } else {
            if notifiObj.notificationType == UserNotificationType.InviteJob.rawValue {
                // in case of invite we need to no need to call service
                redirectToDetail(notiObj: notifiObj)
            } else {
                readNotificationToServer(notificationObj: notifiObj) { response, _ in
                    if response![Constants.ServerKey.status].boolValue {
                        NotificationCenter.default.post(name: .decreaseBadgeCount, object: nil, userInfo: nil)
                        notifiObj.seen = 1
                        self.notificationTableView.reloadData()
                        self.redirectToDetail(notiObj: notifiObj)
                    }
                }
            }
        }
    }

    func redirectToDetail(notiObj: UserNotification) {
        let notificationType = UserNotificationType(rawValue: notiObj.notificationType!)!

        switch notificationType {
        case .acceptJob:
            // open job detail
            goToJobDetail(jobObj: notiObj.jobdetail!)
        case .chatMessgae: break
        // No need any action
        case .completeProfile: break
            // open profile commented on 6/7/18 to remove warning
            //tabBarController?.selectedIndex = 4
        case .deleteJob: break
        // No need any action
        case .hired, .InviteJob:
            // open job detail
            goToJobDetail(jobObj: notiObj.jobdetail!)
        case .jobCancellation:
            // open job detail
            goToJobDetail(jobObj: notiObj.jobdetail!)
        case .verifyDocuments, .licenseAcceptReject: break
            // open edit profile commented on 6/7/18 to remove warning
            //tabBarController?.selectedIndex = 4

        case .other: break
        case .rejectJob:
            goToJobDetail(jobObj: notiObj.jobdetail!)
        }
    }

    func goToJobDetail(jobObj: Job) {
        guard let jobDetailVC = DMJobDetailInitializer.initialize() as? DMJobDetailVC else { return }
        jobDetailVC.fromNotificationVC = false
        jobDetailVC.job = jobObj
        jobDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(jobDetailVC, animated: true)
    }

    func setupLoadingMoreOnTable(tableView: UITableView) {
        let footer = Bundle.main.loadNibNamed("LoadMoreView", owner: nil, options: nil)?[0] as? LoadMoreView
        footer!.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44)
        footer?.layoutIfNeeded()
        footer?.activityIndicator.startAnimating()
        tableView.tableFooterView = footer
    }
}
