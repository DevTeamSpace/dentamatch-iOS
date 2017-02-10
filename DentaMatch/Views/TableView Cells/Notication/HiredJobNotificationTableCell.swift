//
//  HiredJobNotificationTableCell.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 09/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class HiredJobNotificationTableCell: UITableViewCell {
    
    @IBOutlet weak var notificationTextLabel: UILabel!
    @IBOutlet weak var unreadView: UIView!
    @IBOutlet weak var btnJobType: UIButton!
    @IBOutlet weak var jobTypeView: UIView!
    @IBOutlet weak var notificationTimeLabel: UILabel!
    @IBOutlet weak var notificationJobLocationLabel: UILabel!
    
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
    
    func configureHiredJobNotificationTableCell(userNotificationObj:UserNotification) {
        self.notificationTextLabel.text = userNotificationObj.message
        let address = "\(userNotificationObj.jobdetail?.officeName), \(userNotificationObj.jobdetail?.address)"
        self.notificationJobLocationLabel.text = address
        let date = Date.stringToDateForFormatter(date: userNotificationObj.createdAtTime, dateFormate: Date.dateFormatYYYYMMDDHHMMSS())
        notificationTimeLabel.text = timeAgoSince(date)
        if userNotificationObj.jobdetail?.jobType == 1 {
            self.btnJobType.setTitle("Full Time", for: .normal)
        }else if userNotificationObj.jobdetail?.jobType == 2 {
            self.btnJobType.setTitle("Part Time", for: .normal)
        }else if userNotificationObj.jobdetail?.jobType == 3 {
            self.btnJobType.setTitle("Temporary", for: .normal)
        }
        
        
    }
    
}
