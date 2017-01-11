//
//  AboutMeCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class AboutMeCell: UITableViewCell {

    @IBOutlet weak var aboutMeTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.aboutMeTextView.layer.cornerRadius = 5.0
        self.aboutMeTextView.layer.borderWidth = 1.0
        self.aboutMeTextView.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
        self.aboutMeTextView.textContainer.lineFragmentPadding = 12.0

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
