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
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
