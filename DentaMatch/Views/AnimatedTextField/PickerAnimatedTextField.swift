//
//  PickerAnimatedTextField.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 12/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class PickerAnimatedTextField: FloatLabelTextField {

    private var leftTextFieldView:UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textColor = Constants.Color.textFieldTextColor
        self.titleYPadding = 5.0
        self.titleFont = UIFont.fontRegular(fontSize: 12.0)!
        self.titleActiveTextColour = Constants.Color.textFieldPlaceHolderColor
        self.titleTextColour = Constants.Color.textFieldPlaceHolderColor
        leftTextFieldView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))
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

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
