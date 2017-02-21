//
//  NotificationJobTypeTableCell.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 09/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class NotificationJobTypeTableCell: UITableViewCell {
    @IBOutlet weak var notificationTextLabel: UILabel!

    @IBOutlet weak var btnJobType: UIButton!
    @IBOutlet weak var unreadView: UIView!
    @IBOutlet weak var viewForJobType: UIView!
    @IBOutlet weak var notificationTimeLabel: UILabel!
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
    func configureNotificationJobTypeTableCell(userNotificationObj:UserNotification) {
        self.notificationTextLabel.text = userNotificationObj.message
        let date = Date.stringToDateForFormatter(date: userNotificationObj.createdAtTime, dateFormate: Date.dateFormatYYYYMMDDHHMMSS())
        self.notificationTimeLabel.text = timeAgoSince(date)
        if userNotificationObj.jobdetail?.jobType == 1 {
            self.btnJobType.setTitle("Full Time", for: .normal)
        }else if userNotificationObj.jobdetail?.jobType == 2 {
            self.btnJobType.setTitle("Part Time", for: .normal)
        }else if userNotificationObj.jobdetail?.jobType == 3 {
            self.btnJobType.setTitle("Temporary", for: .normal)
        }
        
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
