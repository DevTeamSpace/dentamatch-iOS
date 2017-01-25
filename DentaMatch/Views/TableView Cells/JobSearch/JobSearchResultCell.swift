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
    
    func setCellData(jobSearchResult : JobSearchResultModel) {
        self.lblJobTitle.text = jobSearchResult.jobtitle
        //self.btnFavourite.titleLabel?.text = jobSearchResult.jobtitle
        if jobSearchResult.jobType == 1 {
            self.btnType.titleLabel?.text = "Full Time"
            self.btnType.backgroundColor = UIColor.init(red: 69.0/255.0, green: 177.0/255.0 , blue: 179.0/255.0, alpha: 1.0)
        }
        else {
            self.btnType.titleLabel?.text = "Part Time"
            self.btnType.backgroundColor = UIColor.init(red: 142.0/255.0, green: 207.0/255.0, blue: 126.0/255.0, alpha: 1.0)
        }
        self.lblDistance.text = String(format: "%.1f", jobSearchResult.distance) + " miles"
        self.lblDays.text = jobSearchResult.jobtitle
        self.lblDocName.text = jobSearchResult.officeName
        self.lblAddress.text = jobSearchResult.address
        self.lblJobPostTime.text = jobSearchResult.postTime
    }
}
