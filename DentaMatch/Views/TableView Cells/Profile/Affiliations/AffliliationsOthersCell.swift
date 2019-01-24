//
//  AffliliationsOthersCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class AffliliationsOthersCell: UITableViewCell {
    @IBOutlet var tickButton: UIButton!
    @IBOutlet var otherAffiliationTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        clipsToBounds = true
        otherAffiliationTextView.layer.cornerRadius = 5.0
        otherAffiliationTextView.layer.borderWidth = 1.0
        otherAffiliationTextView.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
        otherAffiliationTextView.textContainer.lineFragmentPadding = 12.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
