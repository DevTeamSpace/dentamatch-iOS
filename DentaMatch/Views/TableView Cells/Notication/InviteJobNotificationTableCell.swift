//
//  InviteJobNotificationTableCell.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 22/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class InviteJobNotificationTableCell: UITableViewCell {
    @IBOutlet var notificationTextLabel: UILabel!
    @IBOutlet var unreadView: UIView!
    @IBOutlet var btnJobType: UIButton!
    @IBOutlet var jobTypeView: UIView!
    @IBOutlet var notificationTimeLabel: UILabel!
    @IBOutlet var notificationJobLocationLabel: UILabel!
    @IBOutlet var btnAccept: UIButton!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var acceptRejectView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        unreadView.layer.cornerRadius = unreadView.bounds.size.height / 2
        unreadView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureInviteJobNotificationTableCell(userNotificationObj:UserNotification) {
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
            self.notificationJobLocationLabel.text = nil
            btnJobType.setTitle("Temporary", for: .normal)
            btnJobType.backgroundColor = Constants.Color.temporaryBackGroundColor
            if userNotificationObj.currentAvailability.count > 0 {
                var dateArr = [Date]()
                for dateStr in userNotificationObj.currentAvailability {
                    let date = Date.stringToDateForFormatter(date: dateStr, dateFormate: "yyyy-MM-dd")
                    dateArr.append(date)
                }
                 dateArr = dateArr.sorted(by: { $0.compare($1) == .orderedAscending })
                var availabilityArr = [String]()
                for date in dateArr {
                    availabilityArr.append(Date.dateToStringForFormatter(date: date, dateFormate: "dd MMM"))
                }
                notificationTextLabel.text = userNotificationObj.message + " for " + availabilityArr.joined(separator: ", ")
            }
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
