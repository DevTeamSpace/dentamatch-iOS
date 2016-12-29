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
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: RegistrationTextField!
    @IBOutlet weak var passwordTextField: RegistrationTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        emailTextField.leftViewLabel?.text = "f"
        passwordTextField.leftViewLabel?.text = "e"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
