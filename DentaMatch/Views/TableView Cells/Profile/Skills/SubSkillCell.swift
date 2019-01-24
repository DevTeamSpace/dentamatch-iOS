//
//  SubSkillCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 13/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class SubSkillCell: UITableViewCell {
    @IBOutlet var tickButton: UIButton!
    @IBOutlet var subSkillLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.color(withHexCode: "0470C0")
        contentView.backgroundColor = UIColor.color(withHexCode: "0470C0")

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
