import UIKit
import RealmSwift

@objc protocol DentistDetailCellDelegate {
    @objc optional func saveOrUnsaveJob()
    @objc optional func seeMoreTags(isExpanded: Bool)
}

class DentistDetailCell: UITableViewCell {
    @IBOutlet var lblPercentSkill: UILabel!
    @IBOutlet var lblDentistName: UILabel!
    @IBOutlet var btnFavourite: UIButton!
    @IBOutlet var btnJobType: UIButton!
    @IBOutlet var lblDays: UILabel!
    @IBOutlet var lblPostTime: UILabel!
    @IBOutlet var lblApplied: UILabel!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    @IBOutlet weak var messageButton: UIButton! {
        didSet {
            messageButton.layer.cornerRadius = 3.0
        }
    }
    
    weak var delegate: DentistDetailCellDelegate?
    var chatObject: ChatObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnJobType.layer.cornerRadius = 3
        lblApplied.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func actionFavourite(_: UIButton) {
        delegate?.saveOrUnsaveJob!()
    }

    func setCellData(job: Job) {
        /* For Job status
         INVITED = 1
         APPLIED = 2
         SHORTLISTED = 3
         HIRED = 4
         REJECTED = 5
         CANCELLED = 6
         */
        messageButton.isHidden = true
        lblApplied.isHidden = true
        lblApplied.textColor = Constants.Color.jobAppliedGreenColor
        switch job.isApplied {
        case 1:
            lblApplied.text = "INVITED"
            lblApplied.isHidden = false
            messageButton.isHidden = false
            
        case 2:
            lblApplied.text = "APPLIED"
            lblApplied.isHidden = false

        case 3:
            lblApplied.text = "INTERVIEWING"
            lblApplied.isHidden = false
            messageButton.isHidden = false

        case 4:
            lblApplied.text = "HIRED"
            lblApplied.isHidden = false
            messageButton.isHidden = false

        case 5:
            lblApplied.text = "REJECTED"
            lblApplied.isHidden = false
            lblApplied.textColor = Constants.Color.rejectedJobColor
        case 6:
            lblApplied.text = "CANCELLED"
            lblApplied.isHidden = false
            lblApplied.textColor = Constants.Color.cancelledJobColor
        default:
            break
        }

        if job.isSaved == 0 {
            self.btnFavourite.setTitle(Constants.DesignFont.notFavourite, for: .normal)
            self.btnFavourite.titleLabel?.textColor = Constants.Color.unSaveJobColor
            self.btnFavourite.setImage(UIImage(named: ""), for: .normal)
        } else {
            btnFavourite.setImage(UIImage(named: "saveStar"), for: .normal)
            btnFavourite.setTitle("", for: .normal)
        }
        if job.jobType == 1 {
            btnJobType.setTitle(Constants.Strings.fullTime, for: .normal)
            btnJobType.backgroundColor = Constants.Color.fullTimeBackgroundColor
        } else if job.jobType == 2 {
            btnJobType.setTitle(Constants.Strings.partTime, for: .normal)
            btnJobType.backgroundColor = Constants.Color.partTimeDaySelectColor
        }
        lblDentistName.text = job.jobtitle
        var partTimeJobDays = [String]()
        if job.isSunday == 1 {
            partTimeJobDays.append(Constants.DaysAbbreviation.sunday)
        }
        if job.isMonday == 1 {
            partTimeJobDays.append(Constants.DaysAbbreviation.monday)
        }
        if job.isTuesday == 1 {
            partTimeJobDays.append(Constants.DaysAbbreviation.tuesday)
        }
        if job.isWednesday == 1 {
            partTimeJobDays.append(Constants.DaysAbbreviation.wednesday)
        }
        if job.isThursday == 1 {
            partTimeJobDays.append(Constants.DaysAbbreviation.thursday)
        }
        if job.isFriday == 1 {
            partTimeJobDays.append(Constants.DaysAbbreviation.friday)
        }
        if job.isSaturday == 1 {
            partTimeJobDays.append(Constants.DaysAbbreviation.saturday)
        }
        lblDays.text = partTimeJobDays.joined(separator: Constants.Strings.comma + Constants.Strings.whiteSpace)
        if job.jobPostedTimeGap == Constants.Strings.zero {
            lblPostTime.text = Constants.Strings.today.uppercased()
        } else if job.jobPostedTimeGap == Constants.Strings.one {
            lblPostTime.text = job.jobPostedTimeGap + Constants.Strings.whiteSpace + Constants.Strings.dayAgo
        } else {
            lblPostTime.text = job.jobPostedTimeGap + Constants.Strings.whiteSpace + Constants.Strings.daysAgo
        }

        if job.jobType == 3 {
            lblDays.text = ""
            // its a temp job
            lblDays.text = "Dates Needed "
            for date in job.jobTypeDates {
                lblDays.text = lblDays.text! + Date.commonDateFormatEEMMDD(dateString: date) + ", "
            }
            lblDays.text = lblDays.text?.dropLastCharacter(2)
        }
        lblPercentSkill.text = String(format: "%.2f", job.percentSkillsMatch) + "%"
    }
}
