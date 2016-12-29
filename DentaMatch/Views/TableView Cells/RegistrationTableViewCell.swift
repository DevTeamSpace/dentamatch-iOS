//
//  RegistrationTableViewCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 26/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit


class RegistrationTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTextField: RegistrationTextField!
    @IBOutlet weak var emailTextField: RegistrationTextField!
    @IBOutlet weak var newPasswordTextField: RegistrationTextField!
    @IBOutlet weak var preferredLocationTextField: RegistrationTextField!
    @IBOutlet weak var helpHintLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    var showButton:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        helpHintLabel.text = "  ⓘ Helps Recruiters to find you easily"
        setupPasswordShowButton()

    }
    
    func setupPasswordShowButton() {
        let rightTextFieldView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: self.newPasswordTextField.frame.height))
        
        showButton = UIButton(type: .system)
        showButton.frame = CGRect(x: 0, y: 0, width: 50, height: self.newPasswordTextField.frame.height)
        showButton.setTitle("Show", for: .normal)
        showButton.titleLabel?.font = UIFont.fontRegular(fontSize: 12.0)!
        showButton.addTarget(self, action: #selector(showPasswordText), for: .touchUpInside)
        showButton.center = rightTextFieldView.center
        rightTextFieldView.addSubview(showButton)
        newPasswordTextField.rightViewMode = .whileEditing
        newPasswordTextField.rightView = rightTextFieldView
    }
    
    func showPasswordText() {
        if self.newPasswordTextField.isSecureTextEntry {
            self.newPasswordTextField.isSecureTextEntry = false
            showButton.setTitle("Hide", for: .normal)
        } else {
            self.newPasswordTextField.isSecureTextEntry = true
            showButton.setTitle("Show", for: .normal)
        }
    }    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        nameTextField.leftViewLabel?.text = "m"
        emailTextField.leftViewLabel?.text = "f"
        newPasswordTextField.leftViewLabel?.text = "e"
        preferredLocationTextField.leftViewLabel?.text = "d"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
