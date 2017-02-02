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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    }
    
}
