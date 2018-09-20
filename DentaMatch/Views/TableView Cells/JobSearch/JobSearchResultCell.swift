//
//  JobSearchResultCell.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 12/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

@objc protocol JobSearchResultCellDelegate {
    @objc optional func saveOrUnsaveJob(index: Int)
}

class JobSearchResultCell: UITableViewCell {
    enum JobType: Int {
        case fullTime = 1
        case partTime = 2
        case temporary = 3
    }

    @IBOutlet var jobTitleLeftConstraint: NSLayoutConstraint!
    @IBOutlet var wagesViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var wagesViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var lblJobTitle: UILabel!
    @IBOutlet var btnFavourite: UIButton!
    @IBOutlet var btnType: UIButton!
    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var lblDays: UILabel!
    @IBOutlet var lblDocName: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblJobPostTime: UILabel!
    @IBOutlet var lblJobWages: UILabel!
    
    weak var delegate: JobSearchResultCellDelegate?
    var index: Int!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnType.layer.cornerRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func setCellData(job: Job) {
        if job.isSaved == 0 {
            btnFavourite.setTitle(Constants.DesignFont.notFavourite, for: .normal)
            btnFavourite.titleLabel?.textColor = Constants.Color.unSaveJobColor
            btnFavourite.setImage(nil, for: .normal)
        } else {
            btnFavourite.setImage(#imageLiteral(resourceName: "saveStar"), for: .normal)
            btnFavourite.setTitle("", for: .normal)
        }

        // As we will not get temp jobs (jobType = 3) in this screen, so we handled the case for 1 and 2 only
        if job.jobType == 1 {
            btnType.setTitle(Constants.Strings.fullTime, for: .normal)
            btnType.backgroundColor = Constants.Color.fullTimeBackgroundColor
        } else if job.jobType == 2 {
            btnType.setTitle(Constants.Strings.partTime, for: .normal)
            btnType.backgroundColor = Constants.Color.partTimeDaySelectColor
        }
        lblJobTitle.text = job.jobtitle

        // Now the lblDistance will be percentage label
        lblDistance.text = String(format: "%.2f", job.percentSkillsMatch) + "%"
        lblDocName.text = job.officeName
        lblAddress.text = job.address
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
        if job.days == Constants.Strings.zero {
            lblJobPostTime.text = Constants.Strings.today
        } else if job.days == Constants.Strings.one {
            lblJobPostTime.text = job.days + Constants.Strings.whiteSpace + Constants.Strings.dayAgo
        } else {
            lblJobPostTime.text = job.days + Constants.Strings.whiteSpace + Constants.Strings.daysAgo
        }
        
        self.configureWagesLabel(job: job)
    }

    @IBAction func actionFavourite(_: UIButton) {
        delegate?.saveOrUnsaveJob!(index: index)
    }

    func handlePartTimeLabel(job: Job) {
        var partTimeJobDays = [String]()

        let jobType = JobType(rawValue: job.jobType)!
        switch jobType {
        case .fullTime:
            lblDays.isHidden = true
            btnType.backgroundColor = Constants.Color.fullTimeBackgroundColor
        case .partTime:
            lblDays.isHidden = false
            btnType.backgroundColor = Constants.Color.partTimeDaySelectColor
        case .temporary:
            lblDays.isHidden = false
            btnType.backgroundColor = Constants.Color.temporaryBackGroundColor
        }

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

        if job.days == Constants.Strings.zero {
            lblJobPostTime.text = Constants.Strings.today
        } else {
            if job.days == "1" {
                lblJobPostTime.text = job.days + Constants.Strings.whiteSpace + "DAY AGO"
            } else {
                lblJobPostTime.text = job.days + Constants.Strings.whiteSpace + Constants.Strings.daysAgo
            }
        }
    }
    
    private func configureWagesLabel(job: Job) {
        if job.jobType == JobType.temporary.rawValue {
            wagesViewHeightConstraint.constant = 40
            wagesViewTopConstraint.constant = 10
            lblJobWages.text = "\(job.wageOffered)"
            
        }else{
            wagesViewHeightConstraint.constant = 0
            wagesViewTopConstraint.constant = 0
        }
    }
}
