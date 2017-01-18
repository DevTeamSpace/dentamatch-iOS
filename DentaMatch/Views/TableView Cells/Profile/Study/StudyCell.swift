//
//  StudyCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class StudyCell: UITableViewCell {

    @IBOutlet weak var headingButton: UIButton!
    @IBOutlet weak var yearOfGraduationTextField: ProfileTextField!
    @IBOutlet weak var schoolNameTextField: ProfileTextField!
    override func awakeFromNib() {
        // Initialization code
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
        self.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
