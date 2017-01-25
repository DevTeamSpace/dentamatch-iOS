//
//  EditProfileHeaderTableCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 17/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class EditProfileHeaderTableCell: UITableViewCell {
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var placeLabel: UILabel!

    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileButton: ProfileImageButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.aboutTextView.textContainer.lineFragmentPadding = 12.0

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillPlaceAndJobTitle(jobTitle:String,place:String) -> NSMutableAttributedString {
        
        if jobTitle.isEmptyField {
            let attributedString = NSMutableAttributedString()
            let placeText = NSAttributedString(string: place, attributes: [NSFontAttributeName:UIFont.fontRegular(fontSize: 16.0)!,NSForegroundColorAttributeName:UIColor.white])
            attributedString.append(placeText)
            return attributedString
        } else {
            let attributedString = NSMutableAttributedString()
            let jobTitleText = NSAttributedString(string: jobTitle, attributes: [NSFontAttributeName:UIFont.fontSemiBold(fontSize: 16.0)!,NSForegroundColorAttributeName:UIColor.white])
            let placeText = NSAttributedString(string: place, attributes: [NSFontAttributeName:UIFont.fontRegular(fontSize: 16.0)!,NSForegroundColorAttributeName:UIColor.white])
            attributedString.append(jobTitleText)
            attributedString.append(NSAttributedString(string: "\n"))
            attributedString.append(placeText)
            return attributedString
        }
        
    }
    
}
