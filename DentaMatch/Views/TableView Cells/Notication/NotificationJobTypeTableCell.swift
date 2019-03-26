import UIKit

protocol NotificationTableCellDelegate: class {
    
    func onMessageButtonTapped(chatObject: ChatObject)
}

class NotificationJobTypeTableCell: UITableViewCell {
    @IBOutlet var notificationTextLabel: UILabel!
    @IBOutlet var btnJobType: UIButton!
    @IBOutlet var unreadView: UIView!
    @IBOutlet weak var messageButton: UIButton! {
        didSet {
            messageButton.addTarget(self, action: #selector(messageButtonAction), for: .touchUpInside)
        }
    }
    @IBOutlet var notificationTimeLabel: UILabel!
    
    weak var delegate: NotificationTableCellDelegate?
    weak var userNotificationObject: UserNotification?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        unreadView.layer.cornerRadius = unreadView.bounds.size.height / 2
        unreadView.clipsToBounds = true
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    func configureNotificationJobTypeTableCell(userNotificationObj: UserNotification) {
        userNotificationObject = userNotificationObj
        
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
        
        if let rawType = userNotificationObj.notificationType, let type =  UserNotificationType(rawValue: rawType),
            type == .acceptJob {
            
            messageButton.isHidden = false
        } else {
            messageButton.isHidden = true
        }
    }
}

extension NotificationJobTypeTableCell {
    
    @objc private func messageButtonAction() {
        guard let notify = userNotificationObject,
            let recruiterId = notify.senderID,
            let officeName = notify.jobdetail?.officeName else { return }
        
        let chatObj = ChatObject(recruiterId: String(recruiterId), officeName: officeName)
        
        delegate?.onMessageButtonTapped(chatObject: chatObj)
    }
}
