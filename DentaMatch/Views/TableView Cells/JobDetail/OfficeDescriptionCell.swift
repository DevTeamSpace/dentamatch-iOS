//
//  OfficeDescriptionCell.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 19/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class OfficeDescriptionCell: UITableViewCell {

    @IBOutlet weak var lblWorkingHours: UILabel!
    
    @IBOutlet weak var lblDressCode: UILabel!
    
    @IBOutlet weak var lblParkingAvail: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
