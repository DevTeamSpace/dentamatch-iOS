//
//  DentistDetailCell.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 18/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DentistDetailCell: UITableViewCell {
    
    @IBOutlet weak var lblDentistName: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var btnJobType: UIButton!
    @IBOutlet weak var lblDays: UILabel!

    @IBOutlet weak var lblPostTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
