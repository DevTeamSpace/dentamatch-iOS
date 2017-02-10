//
//  AboutCell.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 18/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class AboutCell: UITableViewCell {
    
    @IBOutlet weak var lblDentistName: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblOfficeType: UILabel!
    @IBOutlet weak var lblNoOfOpening: UILabel!
    
    @IBOutlet weak var constraintlblNoOfOpeningTop: NSLayoutConstraint!
    @IBOutlet weak var constraintLblNoOfOpeningHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintLblNoOfOpeningValueHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.clipsToBounds = true
        let paragraphStyle = NSMutableParagraphStyle()
        let attributedString = NSMutableAttributedString()
        paragraphStyle.lineSpacing = 130
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.lblAddress.attributedText = attributedString;
        self.lblOfficeType.attributedText = attributedString;
        self.lblDentistName.attributedText = attributedString;
        self.lblNoOfOpening.attributedText = attributedString;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCellData(job : Job) {
        self.lblDentistName.text = job.officeName
        self.lblDistance.text = String(format: "%.1f", job.distance) + Constants.Strings.whiteSpace + Constants.Strings.miles
        self.lblAddress.text = job.address
        self.lblOfficeType.text = job.officeTypeName
        self.lblNoOfOpening.text = "10"
        
        if job.noOfJobs == 0 {
            self.constraintlblNoOfOpeningTop.constant = 0
            self.constraintLblNoOfOpeningHeight.constant = 0
            self.constraintLblNoOfOpeningValueHeight.constant = 0
        }
    }
    
}
