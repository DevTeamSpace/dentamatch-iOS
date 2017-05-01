//
//  EditProfileExperienceCell.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 23/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class EditProfileExperienceCell: UITableViewCell {
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var yearOfExperienceLabel: UILabel!
    @IBOutlet weak var officeNameLabel: UILabel!
    @IBOutlet weak var officeAddressLabel: UILabel!
    @IBOutlet weak var contactInformationLabel: UILabel!
    @IBOutlet weak var reference1Name: UILabel!
    @IBOutlet weak var reference1Mobile: UILabel!
    @IBOutlet weak var reference1Email: UILabel!
    @IBOutlet weak var reference2Name: UILabel!
    @IBOutlet weak var reference2Mobile: UILabel!
    @IBOutlet weak var reference2Email: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
