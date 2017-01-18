//
//  LoginTableViewCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 26/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class LoginTableViewCell: UITableViewCell {

    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var emailTextField: AnimatedLeftViewPHTextField!
    @IBOutlet weak var passwordTextField: AnimatedLeftViewPHTextField!
    
    var showButton:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let rightTextFieldView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: self.passwordTextField.frame.height))

        showButton = UIButton(type: .system)
        showButton.frame = CGRect(x: 0, y: 0, width: 50, height: self.passwordTextField.frame.height)
        showButton.setTitle("Show", for: .normal)
        showButton.titleLabel?.font = UIFont.fontRegular(fontSize: 12.0)!
        showButton.addTarget(self, action: #selector(showPasswordText), for: .touchUpInside)
        showButton.center = rightTextFieldView.center
        rightTextFieldView.addSubview(showButton)
        passwordTextField.rightViewMode = .whileEditing
        passwordTextField.rightView = rightTextFieldView
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        emailTextField.leftViewLabel?.text = "f"
        passwordTextField.leftViewLabel?.text = "e"
    }
    
    func showPasswordText() {
        if self.passwordTextField.isSecureTextEntry {
            self.passwordTextField.isSecureTextEntry = false
            showButton.setTitle("Hide", for: .normal)
        } else {
            self.passwordTextField.isSecureTextEntry = true
            showButton.setTitle("Show", for: .normal)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
