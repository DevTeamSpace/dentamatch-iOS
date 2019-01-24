//
//  RegistrationTextField.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 26/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class AnimatedLeftViewPHTextField: FloatLabelTextField {
    private var leftTextFieldView: UIView?
    var leftViewLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        textColor = Constants.Color.textFieldTextColor
        titleYPadding = 5.0
        titleFont = UIFont.fontRegular(fontSize: 12.0)
        titleActiveTextColour = Constants.Color.textFieldPlaceHolderColor
        titleTextColour = Constants.Color.textFieldPlaceHolderColor
        leftTextFieldView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: frame.size.height))
        leftViewLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: frame.size.height))

        leftViewLabel?.textColor = Constants.Color.textFieldLeftViewModeColor
        leftViewLabel?.textAlignment = .center
        leftViewLabel?.font = UIFont.designFont(fontSize: 18.0)
        leftViewLabel?.center = (leftTextFieldView?.center)!
        leftTextFieldView?.addSubview(leftViewLabel!)
        leftView = leftTextFieldView
        leftViewMode = .always
        layer.cornerRadius = 5.0
        layer.borderWidth = 1.0
        layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
    }

}
