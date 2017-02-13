//
//  CommonTextNotificationTableCell.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 09/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class CommonTextNotificationTableCell: UITableViewCell {
    @IBOutlet weak var notificationTextLabel: UILabel!
    @IBOutlet weak var notificationTimeLabel: UILabel!
    @IBOutlet weak var unreadView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        unreadView.layer.cornerRadius = unreadView.bounds.size.height/2
        unreadView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCommonTextNotificationTableCell(userNotificationObj:UserNotification) {
        self.notificationTextLabel.text = userNotificationObj.message
        let date = Date.stringToDateForFormatter(date: userNotificationObj.createdAtTime, dateFormate: Date.dateFormatYYYYMMDDHHMMSS())
        self.notificationTimeLabel.text = timeAgoSince(date)
    }
    
}
