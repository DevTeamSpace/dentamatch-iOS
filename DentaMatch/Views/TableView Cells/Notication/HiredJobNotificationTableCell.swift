//
//  HiredJobNotificationTableCell.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 09/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class HiredJobNotificationTableCell: UITableViewCell {
    @IBOutlet var notificationTextLabel: UILabel!
    @IBOutlet var unreadView: UIView!
    @IBOutlet var btnJobType: UIButton!
    @IBOutlet var jobTypeView: UIView!
    @IBOutlet var notificationTimeLabel: UILabel!
    @IBOutlet var notificationJobLocationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        unreadView.layer.cornerRadius = unreadView.bounds.size.height / 2
        unreadView.clipsToBounds = true
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureHiredJobNotificationTableCell(userNotificationObj:UserNotification) {
        self.notificationTextLabel.text = userNotificationObj.message
        let address = "\((userNotificationObj.jobdetail?.officeName)!), \((userNotificationObj.jobdetail?.address)!)"
        self.notificationJobLocationLabel.text = address
        let date = Date.stringToDateForFormatter(date: userNotificationObj.createdAtTime, dateFormate: Date.dateFormatYYYYMMDDHHMMSS())
        notificationTimeLabel.text = timeAgoSince(date)
        if userNotificationObj.jobdetail?.jobType == 1 {
            btnJobType.setTitle("Full Time", for: .normal)
            btnJobType.backgroundColor = Constants.Color.fullTimeBackgroundColor
        } else if userNotificationObj.jobdetail?.jobType == 2 {
            btnJobType.setTitle("Part Time", for: .normal)
            btnJobType.backgroundColor = Constants.Color.partTimeDaySelectColor

        } else if userNotificationObj.jobdetail?.jobType == 3 {
            btnJobType.setTitle("Temporary", for: .normal)
            btnJobType.backgroundColor = Constants.Color.temporaryBackGroundColor
        }

        if userNotificationObj.seen == 0 {
            notificationTextLabel.textColor = Constants.Color.notificationUnreadTextColor
            notificationTimeLabel.textColor = Constants.Color.notificationUnreadTimeLabelColor
            notificationJobLocationLabel.textColor = Constants.Color.notificationUnreadTextColor
            unreadView.isHidden = false
        } else {
            unreadView.isHidden = true
            notificationTextLabel.textColor = Constants.Color.notificationreadTextColor
            notificationTimeLabel.textColor = Constants.Color.notificationreadTimeLabelColor
            notificationJobLocationLabel.textColor = Constants.Color.notificationreadTextColor
        }
    }
}
