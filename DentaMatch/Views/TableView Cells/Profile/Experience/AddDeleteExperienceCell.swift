//
//  AddDeleteExperienceCell.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 05/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class AddDeleteExperienceCell: UITableViewCell {
    @IBOutlet var topSpaceOfAddMoreExperience: NSLayoutConstraint!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var addMoreExperienceButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
