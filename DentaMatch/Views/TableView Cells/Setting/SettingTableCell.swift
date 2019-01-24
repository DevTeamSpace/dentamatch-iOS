//
//  SettingTableCell.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 20/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class SettingTableCell: UITableViewCell {
    @IBOutlet var leftConstraintLabel: NSLayoutConstraint!
    @IBOutlet var leftIconImageView: UIImageView!
    @IBOutlet var leftIconLabel: UILabel!
    @IBOutlet var TextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
