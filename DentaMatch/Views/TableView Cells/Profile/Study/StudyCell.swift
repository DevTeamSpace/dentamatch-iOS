//
//  StudyCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class StudyCell: UITableViewCell {
    @IBOutlet var headingButton: UIButton!
    @IBOutlet var yearOfGraduationTextField: ProfileTextField!
    @IBOutlet var schoolNameTextField: ProfileTextField!
    override func awakeFromNib() {
        // Initialization code
        super.awakeFromNib()
        layoutMargins = UIEdgeInsets.zero
        preservesSuperviewLayoutMargins = false
        clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
