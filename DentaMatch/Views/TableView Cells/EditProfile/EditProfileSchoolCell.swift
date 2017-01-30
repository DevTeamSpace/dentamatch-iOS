//
//  EditProfileSchoolCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 27/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class EditProfileSchoolCell: UITableViewCell {

    @IBOutlet weak var universityNameLabel: UILabel!
    @IBOutlet weak var schoolCategoryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func makeUniversityText(school:SelectedSchool) -> String {
        return "\(school.universityName) (\(school.yearOfGraduation))"
    }
    
}
