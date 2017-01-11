//
//  ProfileTextField.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class ProfileTextField: UITextField {

    private var leftTextFieldView:UIView?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
        leftTextFieldView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))
        self.leftView =  leftTextFieldView
        self.leftViewMode = .always

    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
