//
//  ChangePasswordTableCell.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 21/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class ChangePasswordTableCell: UITableViewCell {
    var showButton: UIButton!
    @IBOutlet var passwordTextField: AnimatedLeftViewPHTextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Initialization code
        let rightTextFieldView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: passwordTextField.frame.height))

        showButton = UIButton(type: .system)
        showButton.frame = CGRect(x: 0, y: 0, width: 50, height: passwordTextField.frame.height)
        showButton.setTitle("Show", for: .normal)
        showButton.titleLabel?.font = UIFont.fontRegular(fontSize: 12.0)
        showButton.addTarget(self, action: #selector(showPasswordText), for: .touchUpInside)
        showButton.center = rightTextFieldView.center
        rightTextFieldView.addSubview(showButton)
        passwordTextField.rightViewMode = .whileEditing
        passwordTextField.rightView = rightTextFieldView
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        passwordTextField.leftViewLabel?.text = "e"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func showPasswordText() {
        if passwordTextField.isSecureTextEntry {
            passwordTextField.isSecureTextEntry = false
            showButton.setTitle("Hide", for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            showButton.setTitle("Show", for: .normal)
        }
    }
}
