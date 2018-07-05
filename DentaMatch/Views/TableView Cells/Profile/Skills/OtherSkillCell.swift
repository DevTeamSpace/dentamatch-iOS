//
//  OtherSkillCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 18/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class OtherSkillCell: UITableViewCell {
    @IBOutlet var otherLabel: UILabel!
    @IBOutlet var otherTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        UITextView.appearance().tintColor = UIColor.white

        otherTextView.layer.cornerRadius = 5.0
        otherTextView.layer.borderWidth = 1.0
        otherTextView.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
        otherTextView.textContainer.lineFragmentPadding = 12.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
