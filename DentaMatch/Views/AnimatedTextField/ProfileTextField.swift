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
    var type = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
        leftTextFieldView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))
        self.leftView =  leftTextFieldView
        self.textColor = Constants.Color.textFieldTextColor
        self.leftViewMode = .always

    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if self.type != 0 || action == #selector(delete(_:)) {
            return false
        }
        return true
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
