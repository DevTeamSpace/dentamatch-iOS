//
//  OtherSkillCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 18/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class OtherSkillCell: UITableViewCell {

    @IBOutlet weak var otherLabel: UILabel!
    @IBOutlet weak var otherTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        UITextView.appearance().tintColor = UIColor.white

        self.otherTextView.layer.cornerRadius = 5.0
        self.otherTextView.layer.borderWidth = 1.0
        self.otherTextView.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
        self.otherTextView.textContainer.lineFragmentPadding = 12.0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
