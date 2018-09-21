//
//  AboutCell.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 18/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class AboutCell: UITableViewCell {
    @IBOutlet var googleMapButton: UIButton!
    @IBOutlet var lblDentistName: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblOfficeType: UILabel!
    @IBOutlet var lblNoOfOpening: UILabel!
    @IBOutlet var wagesView: UIView!
    @IBOutlet var wagesLabel: UILabel!
    
    @IBOutlet var constraintlblNoOfOpeningTop: NSLayoutConstraint!
    @IBOutlet var constraintLblNoOfOpeningHeight: NSLayoutConstraint!
    @IBOutlet var constraintLblNoOfOpeningValueHeight: NSLayoutConstraint!
    @IBOutlet var constraintWagesOfferedHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        clipsToBounds = true
        let paragraphStyle = NSMutableParagraphStyle()
        let attributedString = NSMutableAttributedString()
        paragraphStyle.lineSpacing = 130
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        lblAddress.attributedText = attributedString
        lblOfficeType.attributedText = attributedString
        lblDentistName.attributedText = attributedString
        lblNoOfOpening.attributedText = attributedString
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func setCellData(job: Job) {
        lblDentistName.text = job.officeName
//        self.lblDistance.text = String(format: "%.1f", job.distance) + Constants.Strings.whiteSpace + Constants.Strings.miles
        lblAddress.text = job.address
        lblOfficeType.text = job.officeTypeName
        lblNoOfOpening.text = "\(job.noOfJobs)"
        wagesView.isHidden = job.jobType == 3 ? false : true
        constraintWagesOfferedHeight.constant = job.jobType == 3 ? 40 : 0
        // Show total openings in case of temp Jobs only i.e jobType = 3
        if job.jobType == 1 || job.jobType == 2 {
            constraintlblNoOfOpeningTop.constant = 0
            constraintLblNoOfOpeningHeight.constant = 0
            constraintLblNoOfOpeningValueHeight.constant = 0
            constraintWagesOfferedHeight.constant = 0
        }
        if job.jobType == 3 {
            //job.wageOffered = 2.5
            wagesLabel.text = "$\(job.payRate)"
        }
        
    }
}
