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
    
    @IBOutlet weak var disclosureIndicatorView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        unreadView.layer.cornerRadius = unreadView.bounds.size.height/2
        unreadView.clipsToBounds = true
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCommonTextNotificationTableCell(userNotificationObj:UserNotification) {
        self.notificationTextLabel.text = userNotificationObj.message
        let date = Date.stringToDateForFormatter(date: userNotificationObj.createdAtTime, dateFormate: Date.dateFormatYYYYMMDDHHMMSS())
        self.notificationTimeLabel.text = timeAgoSince(date)
        if userNotificationObj.seen == 0 {
            self.notificationTextLabel.textColor = Constants.Color.notificationUnreadTextColor
            self.notificationTimeLabel.textColor = Constants.Color.notificationUnreadTimeLabelColor
            self.unreadView.isHidden = false
        }else {
            self.unreadView.isHidden = true
            self.notificationTextLabel.textColor = Constants.Color.notificationreadTextColor
            self.notificationTimeLabel.textColor = Constants.Color.notificationreadTimeLabelColor
        }

    }
    
}
