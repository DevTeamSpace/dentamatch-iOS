//
//  JobSearchResultCell.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 12/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class JobSearchResultCell: UITableViewCell {

    enum JobType:Int {
        case fullTime = 1
        case partTime = 2
        case temporary = 3
    }
    
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var btnType: UIButton!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var lblDocName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblJobPostTime: UILabel!
    
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
        self.lblJobTitle.text = job.jobtitle
        if job.jobType == 1 {
            self.btnType.titleLabel?.text = Constants.Strings.fullTime
            self.btnType.backgroundColor = Constants.Color.fullTimeBackgroundColor
        }
        else {
            self.btnType.titleLabel?.text = Constants.Strings.partTime
            self.btnType.backgroundColor = Constants.Color.partTimeDaySelectColor
        }
        self.lblDistance.text = String(format: "%.1f", job.distance) + Constants.Strings.whiteSpace + Constants.Strings.miles
        self.lblDocName.text = job.officeName
        self.lblAddress.text = job.address
        var partTimeJobDays = [String]()
        if job.isSunday == 1 {
            partTimeJobDays.append(Constants.Days.sunday)
        }
        if job.isMonday == 1 {
            partTimeJobDays.append(Constants.Days.monday)
        }
        if job.isTuesday == 1 {
            partTimeJobDays.append(Constants.Days.tuesday)
        }
        if job.isWednesday == 1 {
            partTimeJobDays.append(Constants.Days.wednesday)
        }
        if job.isThursday == 1 {
            partTimeJobDays.append(Constants.Days.thursday)
        }
        if job.isFriday == 1 {
            partTimeJobDays.append(Constants.Days.friday)
        }
        if job.isSaturday == 1 {
            partTimeJobDays.append(Constants.Days.saturday)
        }
        
        self.lblDays.text = partTimeJobDays.joined(separator: Constants.Strings.comma)
        
        if job.days == Constants.Strings.zero {
            self.lblJobPostTime.text = Constants.Strings.save
        }
        else {
            self.lblJobPostTime.text = job.days + Constants.Strings.daysAgo
        }
    }
    
    func handlePartTimeLabel(job:Job) {
        var partTimeJobDays = [String]()

        let jobType = JobType(rawValue: job.jobType)!
        switch jobType {
        case .fullTime:
            self.lblDays.isHidden = true
        case .partTime:
            self.lblDays.isHidden = false
        case .temporary:
            self.lblDays.isHidden = false
        }
        
        if job.isSunday == 1 {
            partTimeJobDays.append(Constants.Days.sunday)
        }
        if job.isMonday == 1 {
            partTimeJobDays.append(Constants.Days.monday)
        }
        if job.isTuesday == 1 {
            partTimeJobDays.append(Constants.Days.tuesday)
        }
        if job.isWednesday == 1 {
            partTimeJobDays.append(Constants.Days.wednesday)
        }
        if job.isThursday == 1 {
            partTimeJobDays.append(Constants.Days.thursday)
        }
        if job.isFriday == 1 {
            partTimeJobDays.append(Constants.Days.friday)
        }
        if job.isSaturday == 1 {
            partTimeJobDays.append(Constants.Days.saturday)
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
