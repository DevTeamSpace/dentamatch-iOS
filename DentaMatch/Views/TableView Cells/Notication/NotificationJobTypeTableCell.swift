//
//  NotificationJobTypeTableCell.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 09/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class NotificationJobTypeTableCell: UITableViewCell {
    @IBOutlet var notificationTextLabel: UILabel!
    @IBOutlet var btnJobType: UIButton!
    @IBOutlet var unreadView: UIView!
    @IBOutlet var viewForJobType: UIView!
    @IBOutlet var notificationTimeLabel: UILabel!
    
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

    func configureNotificationJobTypeTableCell(userNotificationObj: UserNotification) {
        notificationTextLabel.text = userNotificationObj.message
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
            unreadView.isHidden = false
        } else {
            unreadView.isHidden = true
            notificationTextLabel.textColor = Constants.Color.notificationreadTextColor
            notificationTimeLabel.textColor = Constants.Color.notificationreadTimeLabelColor
        }
    }
}
