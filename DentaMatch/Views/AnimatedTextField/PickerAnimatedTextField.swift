//
//  PickerAnimatedTextField.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 12/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class PickerAnimatedTextField: FloatLabelTextField {
    private var leftTextFieldView: UIView?

    override func awakeFromNib() {
        super.awakeFromNib()
        textColor = Constants.Color.textFieldTextColor
        titleYPadding = 5.0
        titleFont = UIFont.fontRegular(fontSize: 12.0)
        titleActiveTextColour = Constants.Color.textFieldPlaceHolderColor
        titleTextColour = Constants.Color.textFieldPlaceHolderColor
        leftTextFieldView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: frame.size.height))
        leftView = leftTextFieldView
        leftViewMode = .always
        layer.cornerRadius = 5.0
        layer.borderWidth = 1.0
        layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
    }

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */

    override func canPerformAction(_: Selector, withSender _: Any?) -> Bool {
        return false
    }
}
