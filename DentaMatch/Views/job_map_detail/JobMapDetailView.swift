import Foundation
import UIKit

protocol JobMapDetailViewDelegate: class {
    func onFavoriteButtonTapped(jobIndex: Int)
    func onDetailViewTapped(jobIndex: Int)
}

final class JobMapDetailView: BaseView {
    
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var availableDaysLabel: UILabel!
    @IBOutlet weak var officeNameLabel: UILabel!
    @IBOutlet weak var matchPercentLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var wagesStackView: UIStackView!
    @IBOutlet weak var wagesValueLabel: UILabel!
    
    @IBOutlet weak var jobTypeButton: UIButton! {
        didSet {
            jobTypeButton.layer.cornerRadius = 3.0
        }
    }
    
    weak var delegate: JobMapDetailViewDelegate?
    
    var currentIndex = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
    }
    
    @IBAction func favoriteButtonAction() {
        delegate?.onFavoriteButtonTapped(jobIndex: currentIndex)
    }
    
    func updateWithJob(_ job: Job, index: Int) {
        
        currentIndex = index
        
        if job.isSaved == 0 {
            favoriteButton.setTitle(Constants.DesignFont.notFavourite, for: .normal)
            favoriteButton.titleLabel?.textColor = Constants.Color.unSaveJobColor
            favoriteButton.setImage(nil, for: .normal)
        } else {
            favoriteButton.setImage(#imageLiteral(resourceName: "saveStar"), for: .normal)
            favoriteButton.setTitle("", for: .normal)
        }
        
        // As we will not get temp jobs (jobType = 3) in this screen, so we handled the case for 1 and 2 only
        if job.jobType == 1 {
            jobTypeButton.setTitle(Constants.Strings.fullTime, for: .normal)
            jobTypeButton.backgroundColor = Constants.Color.fullTimeBackgroundColor
        } else if job.jobType == 2 {
            jobTypeButton.setTitle(Constants.Strings.partTime, for: .normal)
            jobTypeButton.backgroundColor = Constants.Color.partTimeDaySelectColor
        }
        jobTitleLabel.text = job.jobtitle
        
        // Now the lblDistance will be percentage label
        matchPercentLabel.text = String(format: "%.2f", job.percentSkillsMatch) + "%"
        officeNameLabel.text = job.officeName
        addressLabel.text = job.address
        
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
        availableDaysLabel.text = partTimeJobDays.joined(separator: Constants.Strings.comma + Constants.Strings.whiteSpace)
        if job.days == Constants.Strings.zero {
            lastUpdatedLabel.text = Constants.Strings.today
        } else if job.days == Constants.Strings.one {
            lastUpdatedLabel.text = job.days + Constants.Strings.whiteSpace + Constants.Strings.dayAgo
        } else {
            lastUpdatedLabel.text = job.days + Constants.Strings.whiteSpace + Constants.Strings.daysAgo
        }
        
        if job.jobType == JobType.temporary.rawValue {
            wagesStackView.isHidden = false
            wagesValueLabel.text = "$\(job.payRate)"
        }else{
            wagesStackView.isHidden = true
        }
    }
    
    @objc private func tapAction() {
        delegate?.onDetailViewTapped(jobIndex: currentIndex)
    }
}
