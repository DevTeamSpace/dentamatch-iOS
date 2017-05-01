//
//  RegistrationTextField.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 26/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class AnimatedLeftViewPHTextField: FloatLabelTextField {

    private var leftTextFieldView:UIView?
    var leftViewLabel:UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textColor = Constants.Color.textFieldTextColor
        self.titleYPadding = 5.0
        self.titleFont = UIFont.fontRegular(fontSize: 12.0)!
        self.titleActiveTextColour = Constants.Color.textFieldPlaceHolderColor
        self.titleTextColour = Constants.Color.textFieldPlaceHolderColor
        leftTextFieldView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: self.frame.size.height))
        leftViewLabel = UILabel(frame:  CGRect(x: 0, y: 0, width: 30, height: self.frame.size.height))
        
        leftViewLabel?.textColor = Constants.Color.textFieldLeftViewModeColor
        leftViewLabel?.textAlignment = .center
        leftViewLabel?.font = UIFont.designFont(fontSize: 18.0)
        leftViewLabel?.center = (leftTextFieldView?.center)!
        leftTextFieldView?.addSubview(leftViewLabel!)
        self.leftView =  leftTextFieldView
        self.leftViewMode = .always
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
