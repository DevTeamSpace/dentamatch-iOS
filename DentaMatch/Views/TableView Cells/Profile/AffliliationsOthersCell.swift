//
//  AffliliationsOthersCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class AffliliationsOthersCell: UITableViewCell {

    @IBOutlet weak var tickButton: UIButton!
    @IBOutlet weak var otherAffiliationTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.clipsToBounds = true
        self.otherAffiliationTextView.layer.cornerRadius = 5.0
        self.otherAffiliationTextView.layer.borderWidth = 1.0
        self.otherAffiliationTextView.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
