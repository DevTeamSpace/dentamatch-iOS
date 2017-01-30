//
//  EditPublicProfileTableCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 19/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class EditPublicProfileTableCell: UITableViewCell {
    @IBOutlet weak var addEditProfileButton: UIButton!
    
    @IBOutlet weak var locationTextField: AnimatedPHTextField!
    @IBOutlet weak var jobTitleTextField: AnimatedPHTextField!
    @IBOutlet weak var lastNameTextField: AnimatedPHTextField!
    @IBOutlet weak var firstNameTextField: AnimatedPHTextField!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var aboutMeTextView: UITextView!

    var placeHolderLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profileButton.layer.cornerRadius = self.profileButton.frame.size.width/2
        self.profileButton.imageView?.contentMode = .scaleAspectFill
        self.profileButton.clipsToBounds = true
        self.aboutMeTextView.layer.cornerRadius = 5.0
        self.aboutMeTextView.layer.borderWidth = 1.0
        self.aboutMeTextView.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
        self.aboutMeTextView.textContainer.lineFragmentPadding = 12.0
        self.jobTitleTextField.type = 1
        self.jobTitleTextField.tintColor = UIColor.clear
        self.locationTextField.type = 1
        addPlaceHolderLabel()
    }
    
    func addPlaceHolderLabel() {
        placeHolderLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 200, height: 20))
        placeHolderLabel.font = UIFont.fontRegular(fontSize: 16.0)
        placeHolderLabel.textColor = UIColor.color(withHexCode: "939393")
        placeHolderLabel.text = "Write a brief introduction"
        self.aboutMeTextView.addSubview(placeHolderLabel)
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
