//
//  AnimatedPHTextField.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 01/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class AnimatedPHTextField: FloatLabelTextField {

    private var leftTextFieldView:UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textColor = kTextFieldTextColor
        self.titleYPadding = 5.0
        self.titleFont = UIFont.fontRegular(fontSize: 12.0)!
        self.titleActiveTextColour = kTextFieldColor
        leftTextFieldView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))
        self.leftView =  leftTextFieldView
        self.leftViewMode = .always
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = kTextFieldBorderColor.cgColor
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
