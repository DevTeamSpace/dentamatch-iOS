import Foundation

extension DMNotificationVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewOutput?.notificationList.count ?? 0
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let notificationList = viewOutput?.notificationList else { return UITableViewCell() }
        
        let notificationObj = notificationList[indexPath.row]
        let notificationType = UserNotificationType(rawValue: notificationObj.notificationType!)!

        switch notificationType {
        case .acceptJob, .jobCancellation, .deleteJob, .rejectJob, .licenseAcceptReject:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationJobTypeTableCell") as? NotificationJobTypeTableCell
            cell?.configureNotificationJobTypeTableCell(userNotificationObj: notificationObj)
            cell?.delegate = self
            return cell!

        case .hired:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HiredJobNotificationTableCell") as? HiredJobNotificationTableCell
            cell?.configureHiredJobNotificationTableCell(userNotificationObj: notificationObj)
            cell?.delegate = self
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
            cell?.delegate = self
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HiredJobNotificationTableCell") as? HiredJobNotificationTableCell
            cell?.configureHiredJobNotificationTableCell(userNotificationObj: notification)
            cell?.delegate = self
            return cell!
        }
    }

    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let notificationList = viewOutput?.notificationList else { return }
        
        if notificationList.count > 9 {
            if indexPath.row == notificationList.count - 2 {
                loadMoreNotification()
            }
        }
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let notificationList = viewOutput?.notificationList else { return nil }
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete", handler: { [weak self] (_: UITableViewRowAction, indexPath: IndexPath) in
            self?.viewOutput?.deleteNotification(notificationList[indexPath.row])
            if #available(iOS 11.0, *) {
                tableView.performBatchUpdates({
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }, completion: { _ in
                    self?.reloadData()
                })
            } else {
                self?.reloadData()
            }
            
        })
        deleteAction.backgroundColor = Constants.Color.cancelJobDeleteColor
        return [deleteAction]
    }

    func loadMoreNotification() {
        viewOutput?.loadingMore()
    }

    @objc func btnAcceptButtonClicked(_ sender: UIButton) {
        guard let notificationList = viewOutput?.notificationList else { return }
        viewOutput?.inviteActionSend(notificationList[sender.tag], actionType: 1)
    }

    @objc func btnRejectButtonClicked(_ sender: UIButton) {
        guard let notificationList = viewOutput?.notificationList else { return }
        alertMessage(title: "Confirm Rejection", message: "Are you sure you want to reject this job invitation?", leftButtonText: "Yes", rightButtonText: "No") { [weak self] (isLeft: Bool) in
            if isLeft {
                self?.viewOutput?.inviteActionSend(notificationList[sender.tag], actionType: 0)
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let notificationList = viewOutput?.notificationList else { return }
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
                viewOutput?.readNotificationToServer(notifiObj)
            }
        }
    }

    func redirectToDetail(notiObj: UserNotification) {
        let notificationType = UserNotificationType(rawValue: notiObj.notificationType!)!

        switch notificationType {
        case .acceptJob:
            // open job detail
            goToJobDetail(jobObj: notiObj.jobdetail!, recruiterId: String(notiObj.senderID ?? 0), notificationId: String(notiObj.notificationID ?? 0))
        case .chatMessgae: break
        // No need any action
        case .completeProfile: break
            // open profile commented on 6/7/18 to remove warning
            //tabBarController?.selectedIndex = 4
        case .deleteJob: break
        // No need any action
        case .hired, .InviteJob:
            // open job detail
            goToJobDetail(jobObj: notiObj.jobdetail!, recruiterId: String(notiObj.senderID ?? 0), notificationId: String(notiObj.notificationID ?? 0))
        case .jobCancellation:
            // open job detail
            goToJobDetail(jobObj: notiObj.jobdetail!, recruiterId: String(notiObj.senderID ?? 0), notificationId: String(notiObj.notificationID ?? 0))
        case .verifyDocuments, .licenseAcceptReject: break
            // open edit profile commented on 6/7/18 to remove warning
            //tabBarController?.selectedIndex = 4

        case .other: break
        case .rejectJob:
            goToJobDetail(jobObj: notiObj.jobdetail!, recruiterId: String(notiObj.senderID ?? 0), notificationId: String(notiObj.notificationID ?? 0))
        }
    }

    func goToJobDetail(jobObj: Job, recruiterId: String?, notificationId: String?) {
        viewOutput?.openJobDetails(job: jobObj, recruiterId: recruiterId, notificationId: notificationId)
    }
}

extension DMNotificationVC: NotificationTableCellDelegate {
    
    func onMessageButtonTapped(chatObject: ChatObject) {
        viewOutput?.openChat(chatObject: chatObject)
    }
}
