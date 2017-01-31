//
//  JobSearchResultCell.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 12/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class JobSearchResultCell: UITableViewCell {

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
            self.btnType.titleLabel?.text = "Full Time"
            self.btnType.backgroundColor = Constants.Color.fullTimeBackgroundColor
        }
        else {
            self.btnType.titleLabel?.text = "Part Time"
            self.btnType.backgroundColor = Constants.Color.partTimeDaySelectColor
        }
        self.lblDistance.text = String(format: "%.1f", job.distance) + " miles"
        self.lblDays.text = job.jobtitle
        self.lblDocName.text = job.officeName
        self.lblAddress.text = job.address
        self.lblJobPostTime.text = job.postTime
    }
}
