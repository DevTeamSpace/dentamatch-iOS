//
//  EditProfileExperienceCell.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 23/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class EditProfileExperienceCell: UITableViewCell {
    @IBOutlet var jobTitleLabel: UILabel!
    @IBOutlet var yearOfExperienceLabel: UILabel!
    @IBOutlet var officeNameLabel: UILabel!
    @IBOutlet var officeAddressLabel: UILabel!
    @IBOutlet var contactInformationLabel: UILabel!
    @IBOutlet var reference1Name: UILabel!
    @IBOutlet var reference1Mobile: UILabel!
    @IBOutlet var reference1Email: UILabel!
    @IBOutlet var reference2Name: UILabel!
    @IBOutlet var reference2Mobile: UILabel!
    @IBOutlet var reference2Email: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
