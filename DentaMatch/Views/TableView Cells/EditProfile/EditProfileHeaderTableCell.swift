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
    
}
