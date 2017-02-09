//
//  DentistDetailCell.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 18/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

@objc protocol DentistDetailCellDelegate {
    
    @objc optional func saveOrUnsaveJob()
}

class DentistDetailCell: UITableViewCell {
    
    @IBOutlet weak var lblDentistName: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var btnJobType: UIButton!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var lblPostTime: UILabel!
    @IBOutlet weak var lblApplied: UILabel!
    
    weak var delegate : DentistDetailCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnJobType.layer.cornerRadius = 3
        self.lblApplied.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    @IBAction func actionFavourite(_ sender: UIButton) {
        self.delegate?.saveOrUnsaveJob!()
    }
    
    func setCellData(job : Job) {
        if job.isApplied == 1 {
            self.lblApplied.isHidden = false
        }
        else {
            self.lblApplied.isHidden = true
        }
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
            self.btnJobType.setTitle(Constants.Strings.fullTime, for: .normal)
            self.btnJobType.backgroundColor = Constants.Color.fullTimeBackgroundColor
        }
        else if job.jobType == 2 {
            self.btnJobType.setTitle(Constants.Strings.partTime, for: .normal)
            self.btnJobType.backgroundColor = Constants.Color.partTimeDaySelectColor
        }
        self.lblDentistName.text = job.jobtitle
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
        if job.jobPostedTimeGap == Constants.Strings.zero {
            self.lblPostTime.text = Constants.Strings.today
        }
        else if job.jobPostedTimeGap == Constants.Strings.one {
            self.lblPostTime.text = job.days + Constants.Strings.whiteSpace + Constants.Strings.dayAgo
        }
        else {
            self.lblPostTime.text = job.jobPostedTimeGap + Constants.Strings.whiteSpace + Constants.Strings.daysAgo
        }
    }
}
