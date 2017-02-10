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
        case .verifyDocuments,.completeProfile,.chatMessgae,.other:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextNotificationTableCell") as? CommonTextNotificationTableCell
            cell?.configureCommonTextNotificationTableCell(userNotificationObj: notificationObj)
            return cell!
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
