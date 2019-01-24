//
//  EditPublicProfileTableCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 19/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class EditPublicProfileTableCell: UITableViewCell {
    @IBOutlet var licenseStateConstraint: NSLayoutConstraint!

    @IBOutlet var licenseStateTopConstraint: NSLayoutConstraint!
    @IBOutlet var addEditProfileButton: UIButton!

    @IBOutlet var preferredJobLocationTextField: AnimatedPHTextField!

    @IBOutlet var licenseNumberTextField: AnimatedPHTextField!

    @IBOutlet var stateTextField: AnimatedPHTextField!
    @IBOutlet var jobTitleTextField: AnimatedPHTextField!
    @IBOutlet var lastNameTextField: AnimatedPHTextField!
    @IBOutlet var firstNameTextField: AnimatedPHTextField!
    @IBOutlet var profileButton: UIButton!
    @IBOutlet var aboutMeTextView: UITextView!

    var placeHolderLabel: UILabel!
    private var stateFieldHandler: (String?) -> Void = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileButton.layer.cornerRadius = profileButton.frame.size.width / 2
        profileButton.imageView?.contentMode = .scaleAspectFill
        profileButton.clipsToBounds = true
        aboutMeTextView.layer.cornerRadius = 5.0
        aboutMeTextView.layer.borderWidth = 1.0
        aboutMeTextView.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
        aboutMeTextView.textContainer.lineFragmentPadding = 12.0
        jobTitleTextField.type = 1
        jobTitleTextField.tintColor = UIColor.clear
        preferredJobLocationTextField.type = 1
        licenseNumberTextField.type = 1
        // Right View for drop down
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: jobTitleTextField.frame.size.height))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: jobTitleTextField.frame.size.height))
        label.font = UIFont.designFont(fontSize: 16.0)
        label.text = "c"
        label.textColor = UIColor.color(withHexCode: "a0a0a0")
        label.textAlignment = .center
        label.center = rightView.center
        rightView.addSubview(label)
        jobTitleTextField.rightView = rightView
        jobTitleTextField.rightView?.isUserInteractionEnabled = false
        jobTitleTextField.rightViewMode = .always

        addPlaceHolderLabel()
        stateTextField.delegate = self
    }

    func addPlaceHolderLabel() {
        placeHolderLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 250, height: 60))
        placeHolderLabel.font = UIFont.fontRegular(fontSize: 16.0)
        placeHolderLabel.textColor = UIColor.color(withHexCode: "939393")
        placeHolderLabel.numberOfLines = 0
        placeHolderLabel.text = "Introduce yourself and tell us what you're looking for. What can you bring to the office?"
        aboutMeTextView.addSubview(placeHolderLabel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func stateFieldAction(_ handler: @escaping (String?) -> Void) {
        stateFieldHandler = handler
    }
    
    
}

extension EditPublicProfileTableCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == stateTextField {
            stateTextField.resignFirstResponder()
            guard let keyword = self.stateTextField?.text else {
                stateFieldHandler(nil)
                return
                
            }
            stateFieldHandler(keyword.trimText)
        }
    }
}
