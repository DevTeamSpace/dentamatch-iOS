//
//  RegistrationTextField.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 26/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class RegistrationTextField: UITextField {

    private var leftViewTextField:UIView?
    var leftViewLabel:UILabel?
    
    override func awakeFromNib() {
        leftViewTextField = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: self.frame.size.height))
        leftViewLabel = UILabel(frame:  CGRect(x: 0, y: 0, width: 30, height: self.frame.size.height))
        
        leftViewLabel?.textColor = kTextFieldColor
        leftViewLabel?.textAlignment = .center
        leftViewLabel?.font = UIFont.designFont(fontSize: 16.0)
        leftViewLabel?.center = (leftViewTextField?.center)!
        leftViewTextField?.addSubview(leftViewLabel!)
        self.leftView =  leftViewTextField
        self.leftViewMode = .always
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = kTextFieldColor.cgColor
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
