//
//  OtherSubSkillTableCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 18/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class OtherSubSkillTableCell: UITableViewCell {
    @IBOutlet var tickButton: UIButton!
    @IBOutlet var otherTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor.color(withHexCode: "0470C0")
        contentView.backgroundColor = UIColor.color(withHexCode: "0470C0")

        clipsToBounds = true

        otherTextView.layer.cornerRadius = 5.0
        otherTextView.layer.borderWidth = 1.0
        otherTextView.layer.borderColor = UIColor.white.cgColor
        otherTextView.textContainer.lineFragmentPadding = 12.0
        otherTextView.backgroundColor = UIColor.color(withHexCode: "0470C0")
//        UITextView.appearance().tintColor = UIColor.white
        otherTextView.tintColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
