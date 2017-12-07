//
//  JobSearchResultCell.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 12/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

@objc protocol JobSearchResultCellDelegate {
    
    @objc optional func saveOrUnsaveJob(index : Int)
}

class JobSearchResultCell: UITableViewCell {

    enum JobType:Int {
        case fullTime = 1
        case partTime = 2
        case temporary = 3
    }
    @IBOutlet weak var jobTitleLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var btnType: UIButton!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var lblDocName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblJobPostTime: UILabel!
    
    weak var delegate : JobSearchResultCellDelegate?
    var index : Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnType.layer.cornerRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCellData(job : Job) {
        if job.isSaved == 0 {
            self.btnFavourite.setTitle(Constants.DesignFont.notFavourite, for: .normal)
            self.btnFavourite.titleLabel?.textColor = Constants.Color.unSaveJobColor
            self.btnFavourite.setImage(UIImage(named:""), for: .normal)
        }
        else {
            self.btnFavourite.setImage(UIImage(named:"saveStar"), for: .normal)
            self.btnFavourite.setTitle("", for: .normal)
        }
        if job.jobType == 1 {
            self.btnType.setTitle(Constants.Strings.fullTime, for: .normal)
            self.btnType.backgroundColor = Constants.Color.fullTimeBackgroundColor
        }
        else if job.jobType == 2 {
            self.btnType.setTitle(Constants.Strings.partTime, for: .normal)
            self.btnType.backgroundColor = Constants.Color.partTimeDaySelectColor
        }
        self.lblJobTitle.text = job.jobtitle
        
        //Now the lblDistance will be percentage label
        self.lblDistance.text = String(format: "%.2f", 98.7877) + " %"
        self.lblDocName.text = job.officeName
        self.lblAddress.text = job.address
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
        self.lblDays.text = partTimeJobDays.joined(separator: Constants.Strings.comma + Constants.Strings.whiteSpace)
        if job.days == Constants.Strings.zero {
            self.lblJobPostTime.text = Constants.Strings.today
        }
        else if job.days == Constants.Strings.one{
            self.lblJobPostTime.text = job.days + Constants.Strings.whiteSpace + Constants.Strings.dayAgo
        }
        else {
            self.lblJobPostTime.text = job.days + Constants.Strings.whiteSpace + Constants.Strings.daysAgo
        }
    }
    
    @IBAction func actionFavourite(_ sender: UIButton) {
        self.delegate?.saveOrUnsaveJob!(index: index)
    }
    
    func handlePartTimeLabel(job:Job) {
        var partTimeJobDays = [String]()

        let jobType = JobType(rawValue: job.jobType)!
        switch jobType {
        case .fullTime:
            self.lblDays.isHidden = true
            self.btnType.backgroundColor = Constants.Color.fullTimeBackgroundColor
        case .partTime:
            self.lblDays.isHidden = false
            self.btnType.backgroundColor = Constants.Color.partTimeDaySelectColor
        case .temporary:
            self.lblDays.isHidden = false
            self.btnType.backgroundColor = Constants.Color.temporaryBackGroundColor
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

        self.lblDays.text = partTimeJobDays.joined(separator: Constants.Strings.comma + Constants.Strings.whiteSpace)
        
        if job.days == Constants.Strings.zero {
            self.lblJobPostTime.text = Constants.Strings.today
        }
        else {
            if job.days == "1" {
                self.lblJobPostTime.text = job.days + Constants.Strings.whiteSpace + "DAY AGO"
            } else {
            self.lblJobPostTime.text = job.days + Constants.Strings.whiteSpace + Constants.Strings.daysAgo
            }
        }
    }
}
