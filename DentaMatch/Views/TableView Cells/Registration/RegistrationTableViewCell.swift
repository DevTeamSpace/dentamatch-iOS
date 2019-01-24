//
//  RegistrationTableViewCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 26/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class RegistrationTableViewCell: UITableViewCell {
    @IBOutlet var firstNameTextField: AnimatedLeftViewPHTextField!

    @IBOutlet var lastNameTextField: AnimatedLeftViewPHTextField!

    @IBOutlet var acceptTermsButton: UIButton!
    @IBOutlet var termsAndConditionsTextView: UITextView!
    @IBOutlet var emailTextField: AnimatedLeftViewPHTextField!
    @IBOutlet var newPasswordTextField: AnimatedLeftViewPHTextField!
    @IBOutlet var preferredLocationTextField: AnimatedLeftViewPHTextField!
    @IBOutlet var helpHintLabel: UILabel!

    var showButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        helpHintLabel.text = "  ⓘ Helps Dental Offices find you easily."
        setupPasswordShowButton()

        let attributedString = NSMutableAttributedString(string: "I agree to the Terms and Conditions and Privacy Policy  ")
        attributedString.addAttribute(NSAttributedString.Key.link, value: "openTermsAndConditions", range: NSRange(location: 14, length: 21))
        attributedString.addAttribute(NSAttributedString.Key.link, value: "openPrivacyPolicy", range: NSRange(location: 40, length: 14))
        attributedString.addAttributes([NSAttributedString.Key.font: UIFont.fontRegular(fontSize: 14.0), NSAttributedString.Key.foregroundColor: UIColor.color(withHexCode: "383838")], range: NSRange(location: 0, length: 54))
        termsAndConditionsTextView.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.color(withHexCode: "1587c9")
        ]
        termsAndConditionsTextView.isScrollEnabled = false
        termsAndConditionsTextView.attributedText = attributedString
    }

    func setupPasswordShowButton() {
        let rightTextFieldView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: newPasswordTextField.frame.height))

        showButton = UIButton(type: .system)
        showButton.frame = CGRect(x: 0, y: 0, width: 50, height: newPasswordTextField.frame.height)
        showButton.setTitle("Show", for: .normal)
        showButton.titleLabel?.font = UIFont.fontRegular(fontSize: 12.0)
        showButton.addTarget(self, action: #selector(showPasswordText), for: .touchUpInside)
        showButton.center = rightTextFieldView.center
        rightTextFieldView.addSubview(showButton)
        newPasswordTextField.rightViewMode = .whileEditing
        newPasswordTextField.rightView = rightTextFieldView
    }

    @objc func showPasswordText() {
        if newPasswordTextField.isSecureTextEntry {
            newPasswordTextField.isSecureTextEntry = false
            showButton.setTitle("Hide", for: .normal)
        } else {
            newPasswordTextField.isSecureTextEntry = true
            showButton.setTitle("Show", for: .normal)
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        firstNameTextField.leftViewLabel?.text = "m"
        lastNameTextField.leftViewLabel?.text = "m"
        emailTextField.leftViewLabel?.text = "f"
        newPasswordTextField.leftViewLabel?.text = "e"
        preferredLocationTextField.leftViewLabel?.text = "d"
    }
}
