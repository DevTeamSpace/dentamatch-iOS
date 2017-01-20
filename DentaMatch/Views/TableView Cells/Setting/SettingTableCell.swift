//
//  SettingTableCell.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 20/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class SettingTableCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var TextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
