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
    
    class func makeUniversityText(school:SelectedSchool) -> String {
        return "\(school.universityName) (\(school.yearOfGraduation))"
    }
    
    class func requiredHeight(school:SelectedSchool) -> CGFloat{
        var length1:CGFloat = 0
        let font = UIFont.fontSemiBold(fontSize: 14.0)
        var label:UILabel = UILabel(frame: CGRect(x:0, y:0, width:Utilities.ScreenSize.SCREEN_WIDTH - 40, height:CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = makeUniversityText(school: school)
        label.sizeToFit()
        length1 = label.frame.height
        label = UILabel(frame: CGRect(x:0, y:0, width:Utilities.ScreenSize.SCREEN_WIDTH - 40, height:CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.fontRegular(fontSize: 13.0)
        label.text = school.schoolCategoryName
        label.sizeToFit()
        return length1 + label.frame.height + 33
    }
}
